Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Nov 2006 06:58:01 -0800 (PST)
Received: from nz-out-0102.google.com (nz-out-0102.google.com [64.233.162.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAKEvqaG024848
	for <xfs@oss.sgi.com>; Mon, 20 Nov 2006 06:57:53 -0800
Received: by nz-out-0102.google.com with SMTP id z6so826696nzd
        for <xfs@oss.sgi.com>; Mon, 20 Nov 2006 06:57:03 -0800 (PST)
Message-ID: <9a8748490611200632n3b545698h295631460a212b9b@mail.gmail.com>
Date: Mon, 20 Nov 2006 15:32:43 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][RFC][resend] potential NULL pointer deref in XFS on failed mount
In-Reply-To: <9a8748490611161418l4d5a773k76cf7061d73c8a51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2046_28541952.1164033163623"
References: <200611162218.26945.jesper.juhl@gmail.com>
	 <20061116220958.GE11034@melbourne.sgi.com>
	 <9a8748490611161418l4d5a773k76cf7061d73c8a51@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Andrew Morton <akpm@osdl.org>

------=_Part_2046_28541952.1164033163623
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 16/11/06, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 16/11/06, David Chinner <dgc@sgi.com> wrote:
> > On Thu, Nov 16, 2006 at 10:18:26PM +0100, Jesper Juhl wrote:
> > > (got no reply on this when I originally send it on 20061031, so resending
> > >  now that a bit of time has passed.  The patch still applies cleanly to
> > >  Linus' git tree as of today.)
> > >
> > >
> > > The Coverity checker spotted a potential problem in XFS.
> > >
> > > The problem is that if, in xfs_mount(), this code triggers:
> > >
> > >       ...
> > >       if (!mp->m_logdev_targp)
> > >               goto error0;
> > >       ...
> > >
> > > Then we'll end up calling xfs_unmountfs_close() with a NULL
> > > 'mp->m_logdev_targp'.
> > > This in turn will result in a call to xfs_free_buftarg() with its 'btp'
> > > argument == NULL. xfs_free_buftarg() dereferences 'btp' leading to
> > > a NULL pointer dereference and crash.
> >
> > Interesting that coverity found that, but failed to find the other
> > leaks in that function from exactly the same code and error
> > case.....
> >
> > > I think this can happen, since the fatal call to xfs_free_buftarg()
> > > happens when 'm_logdev_targp != m_ddev_targp' and due to a check of
> > > 'm_ddev_targp' against NULL in xfs_mount() (and subsequent return if it is
> > > NULL) the two will never both be NULL when we hit the error0 label from
> > > the two lines cited above.
> > >
> > > Comments welcome (please keep me on Cc: on replies).
> > >
> > > Here's a proposed patch to fix this by testing 'btp' against NULL in
> > > xfs_free_buftarg().
> >
> > Not the right fix - we should only be trying to free valid
> > buftargs, which means xfs_unmountfs_close() is the correct
> > place to fix this....
> >
>
> Ok.
>
> > e.g:
> >
> > -       if (mp->m_logdev_targp != mp->m_ddev_targp)
> > +       if (mp->m_logdev_targp && (mp->m_logdev_targp != mp->m_ddev_targp))
> >
> > As to the afore-mentioned leaks, if we fail to allocate a realtime
> > buftarg, then we will leak a reference to both the rtdev and logdev,
> > and if we fail to allocate an external log buftarg we'll leak a
> > reference to the logdev. i.e., we fail to do one or both of:
> >
> >         xfs_blkdev_put(logdev);
> >         xfs_blkdev_put(rtdev);
> >
> > To remove the bdev references we may have gained earlier. Normally,
> > these references are released by xfs_free_buftarg(), but because we
> > failed to allocate the buftarg, we can't drop the references via
> > that method....
> >
>

How about something like the attached patch ?

(sorry about the attachment, but I can't inline the patch from my
current location - a whitespace damaged version is below though for
easy review)



Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_vfsops.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9dfae18..3497128 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1135,7 +1135,7 @@ #endif
 void
 xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
 {
-       if (mp->m_logdev_targp != mp->m_ddev_targp)
+       if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
                xfs_free_buftarg(mp->m_logdev_targp, 1);
        if (mp->m_rtdev_targp)
                xfs_free_buftarg(mp->m_rtdev_targp, 1);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index 62336a4..6d7e8f1 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -473,13 +473,19 @@ xfs_mount(
        }
        if (rtdev) {
                mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
-               if (!mp->m_rtdev_targp)
+               if (!mp->m_rtdev_targp) {
+                       xfs_blkdev_put(logdev);
+                       xfs_blkdev_put(rtdev);
                        goto error0;
+               }
        }
        mp->m_logdev_targp = (logdev && logdev != ddev) ?
                                xfs_alloc_buftarg(logdev, 1) : mp->m_ddev_targp;
-       if (!mp->m_logdev_targp)
+       if (!mp->m_logdev_targp) {
+               xfs_blkdev_put(logdev);
+               xfs_blkdev_put(rtdev);
                goto error0;
+       }

        /*
         * Setup flags based on mount(2) options and then the superblock


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

------=_Part_2046_28541952.1164033163623
Content-Type: text/plain; name="patch.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch.txt"
X-Attachment-Id: f_euqza2rt

ClNpZ25lZC1vZmYtYnk6IEplc3BlciBKdWhsIDxqZXNwZXIuanVobEBnbWFp
bC5jb20+Ci0tLQoKIGZzL3hmcy94ZnNfbW91bnQuYyAgfCAgICAyICstCiBm
cy94ZnMveGZzX3Zmc29wcy5jIHwgICAxMCArKysrKysrKy0tCiAyIGZpbGVz
IGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy94ZnMveGZzX21vdW50LmMgYi9mcy94ZnMveGZzX21v
dW50LmMKaW5kZXggOWRmYWUxOC4uMzQ5NzEyOCAxMDA2NDQKLS0tIGEvZnMv
eGZzL3hmc19tb3VudC5jCisrKyBiL2ZzL3hmcy94ZnNfbW91bnQuYwpAQCAt
MTEzNSw3ICsxMTM1LDcgQEAgI2VuZGlmCiB2b2lkCiB4ZnNfdW5tb3VudGZz
X2Nsb3NlKHhmc19tb3VudF90ICptcCwgc3RydWN0IGNyZWQgKmNyKQogewot
CWlmIChtcC0+bV9sb2dkZXZfdGFyZ3AgIT0gbXAtPm1fZGRldl90YXJncCkK
KwlpZiAobXAtPm1fbG9nZGV2X3RhcmdwICYmIG1wLT5tX2xvZ2Rldl90YXJn
cCAhPSBtcC0+bV9kZGV2X3RhcmdwKQogCQl4ZnNfZnJlZV9idWZ0YXJnKG1w
LT5tX2xvZ2Rldl90YXJncCwgMSk7CiAJaWYgKG1wLT5tX3J0ZGV2X3Rhcmdw
KQogCQl4ZnNfZnJlZV9idWZ0YXJnKG1wLT5tX3J0ZGV2X3RhcmdwLCAxKTsK
ZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfdmZzb3BzLmMgYi9mcy94ZnMveGZz
X3Zmc29wcy5jCmluZGV4IDYyMzM2YTQuLjZkN2U4ZjEgMTAwNjQ0Ci0tLSBh
L2ZzL3hmcy94ZnNfdmZzb3BzLmMKKysrIGIvZnMveGZzL3hmc192ZnNvcHMu
YwpAQCAtNDczLDEzICs0NzMsMTkgQEAgeGZzX21vdW50KAogCX0KIAlpZiAo
cnRkZXYpIHsKIAkJbXAtPm1fcnRkZXZfdGFyZ3AgPSB4ZnNfYWxsb2NfYnVm
dGFyZyhydGRldiwgMSk7Ci0JCWlmICghbXAtPm1fcnRkZXZfdGFyZ3ApCisJ
CWlmICghbXAtPm1fcnRkZXZfdGFyZ3ApIHsKKwkJCXhmc19ibGtkZXZfcHV0
KGxvZ2Rldik7CisJCQl4ZnNfYmxrZGV2X3B1dChydGRldik7CiAJCQlnb3Rv
IGVycm9yMDsKKwkJfQogCX0KIAltcC0+bV9sb2dkZXZfdGFyZ3AgPSAobG9n
ZGV2ICYmIGxvZ2RldiAhPSBkZGV2KSA/CiAJCQkJeGZzX2FsbG9jX2J1ZnRh
cmcobG9nZGV2LCAxKSA6IG1wLT5tX2RkZXZfdGFyZ3A7Ci0JaWYgKCFtcC0+
bV9sb2dkZXZfdGFyZ3ApCisJaWYgKCFtcC0+bV9sb2dkZXZfdGFyZ3ApIHsK
KwkJeGZzX2Jsa2Rldl9wdXQobG9nZGV2KTsKKwkJeGZzX2Jsa2Rldl9wdXQo
cnRkZXYpOwogCQlnb3RvIGVycm9yMDsKKwl9CiAKIAkvKgogCSAqIFNldHVw
IGZsYWdzIGJhc2VkIG9uIG1vdW50KDIpIG9wdGlvbnMgYW5kIHRoZW4gdGhl
IHN1cGVyYmxvY2sK

------=_Part_2046_28541952.1164033163623--
