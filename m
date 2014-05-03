Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16C337F53
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 01:19:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A332BAC003
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 23:19:07 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id BtHo7a6hU99tXMlX for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 23:19:05 -0700 (PDT)
Date: Sat, 3 May 2014 02:18:56 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1461962146.20984.1399097936577.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140502000508.GA26353@dastard>
References: <20140502000508.GA26353@dastard>
Subject: Re: [ANNOUNCE] xfsprogs: 3.2.0-rc2 release tagged
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_20982_860430083.1399097936574"
Reply-To: Nathan Scott <nathans@debian.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

------=_Part_20982_860430083.1399097936574
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Dave,

----- Original Message -----
> [...]
> This commit has been tagged with v3.2.0-rc2. I'd like everyone who
> can test this to test it, as all the issues that needed to be solved
> before a release could be made have now been addressed. If there are
> no new regressions or critical issues reported in the next week or
> so, I will make an official 3.2.0 release. So, please test. :)
> 

I came across a couple of trivial build warnings when doing a test
build, and added a doc note for the debian/changelog - updates are
in a git tree over here if you'd like to pull 'em in...

Changes committed to git://oss.sgi.com/nathans/xfsprogs.git master

 debian/changelog |    7 +++++++
 libxfs/rdwr.c    |    5 +++--
 po/de.po         |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

commit 75b480dad5f54d10e77750b2cf8793c04aa5537a
Author: Nathan Scott <nathans@debian.org>
Date:   Sat May 3 16:13:00 2014 +1000

    Update debian changelog in preparation for pending release
    
    In particular, add a note to the changelog about the added
    dh_autoconf use so the BTS will be updated appropriately.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit ce5da129319024236ce7e1af6b0f1fb448bcf4c7
Author: Nathan Scott <nathans@debian.org>
Date:   Sat May 3 16:10:38 2014 +1000

    Fix msgfmt warning when building the German translation
    
    Use the same header present in the Polish language files to
    resolve the following warning in the de.po build:
        [MSGFMT] de.mo
    de.po:7: warning: header field 'Language' missing in header
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit b47c8cae3637a81c50a7f1e42938fc20d947f3aa
Author: Nathan Scott <nathans@debian.org>
Date:   Sat May 3 16:09:03 2014 +1000

    Fix 32 bit build warning in libxfs, xfs_daddr_t printing
    
    Add the usual type casts to resolve the following warnings:
    rdwr.c: In function 'libxfs_getbufr_map':
    rdwr.c:499:4: warning: format '%lx' expects argument of type 'long unsigned int', but argument 5 has type 'xfs_daddr_t' [-Wformat]
    rdwr.c:499:4: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type 'xfs_daddr_t' [-Wformat]
    
    Signed-off-by: Nathan Scott <nathans@debian.org>


--
Nathan

------=_Part_20982_860430083.1399097936574
Content-Type: text/x-patch; name=xfsprogs-warnings.patch
Content-Disposition: attachment; filename=xfsprogs-warnings.patch
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RlYmlhbi9jaGFuZ2Vsb2cgYi9kZWJpYW4vY2hhbmdlbG9nCmluZGV4IDA5
MzVlMDcuLmM3OTBjNzUgMTAwNjQ0Ci0tLSBhL2RlYmlhbi9jaGFuZ2Vsb2cKKysrIGIvZGViaWFu
L2NoYW5nZWxvZwpAQCAtMSwzICsxLDkgQEAKK3hmc3Byb2dzICgzLjIuMCkgdW5zdGFibGU7IHVy
Z2VuY3k9bG93CisKKyAgKiBOZXcgdXBzdHJlYW0gcmVsZWFzZQorCisgLS0gTmF0aGFuIFNjb3R0
IDxuYXRoYW5zQGRlYmlhbi5vcmc+ICBGcmksIDAyIE1heSAyMDE0IDEwOjE5OjM0ICsxMDAwCisK
IHhmc3Byb2dzICgzLjEuMTEpIHVuc3RhYmxlOyB1cmdlbmN5PWxvdwogCiAgICogTmV3IHVwc3Ry
ZWFtIHJlbGVhc2UKZGlmZiAtLWdpdCBhL2xpYnhmcy9yZHdyLmMgYi9saWJ4ZnMvcmR3ci5jCmlu
ZGV4IGVhNGJkZmQuLjU3YzEyYzEgMTAwNjQ0Ci0tLSBhL2xpYnhmcy9yZHdyLmMKKysrIGIvbGli
eGZzL3Jkd3IuYwpAQCAtNDk1LDggKzQ5NSw5IEBAIGxpYnhmc19nZXRidWZyX21hcChzdHJ1Y3Qg
eGZzX2J1ZnRhcmcgKmJ0cCwgeGZzX2RhZGRyX3QgYmxrbm8sIGludCBiYmxlbiwKIAogCWlmIChi
bGtubyAhPSBtYXBbMF0uYm1fYm4pIHsKIAkJZnByaW50ZihzdGRlcnIsCi0JCQlfKCIlczogJXMg
bWFwIGJsa25vICVseCBkb2Vzbid0IG1hdGNoIGtleSAlbHhcbiIpLAotCQkJcHJvZ25hbWUsIF9f
RlVOQ1RJT05fXywgbWFwWzBdLmJtX2JuLCBibGtubyk7CisJCQlfKCIlczogJXMgbWFwIGJsa25v
IDB4JWxseCBkb2Vzbid0IG1hdGNoIGtleSAweCVsbHhcbiIpLAorCQkJcHJvZ25hbWUsIF9fRlVO
Q1RJT05fXywgKGxvbmcgbG9uZyltYXBbMF0uYm1fYm4sCisJCQkobG9uZyBsb25nKWJsa25vKTsK
IAkJZXhpdCgxKTsKIAl9CiAKZGlmZiAtLWdpdCBhL3BvL2RlLnBvIGIvcG8vZGUucG8KaW5kZXgg
NTczMzgwZS4uYTEzYjVjYyAxMDA2NDQKLS0tIGEvcG8vZGUucG8KKysrIGIvcG8vZGUucG8KQEAg
LTExLDYgKzExLDcgQEAgbXNnc3RyICIiCiAiUE8tUmV2aXNpb24tRGF0ZTogMjAwOS0xMC0yMSAy
MTowOCswMTAwXG4iCiAiTGFzdC1UcmFuc2xhdG9yOiBDaHJpcyBMZWljayA8Yy5sZWlja0B2b2xs
YmlvLmRlPlxuIgogIkxhbmd1YWdlLVRlYW06ICBHZXJtYW4gPGRlYmlhbi1sMTBuLWdlcm1hbkBs
aXN0cy5kZWJpYW4ub3JnPlxuIgorIkxhbmd1YWdlOiBkZVxuIgogIk1JTUUtVmVyc2lvbjogMS4w
XG4iCiAiQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04XG4iCiAiQ29udGVu
dC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdFxuIgo=
------=_Part_20982_860430083.1399097936574
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_20982_860430083.1399097936574--
