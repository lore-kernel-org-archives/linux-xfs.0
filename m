Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:54357 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdJJJQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 05:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <20171005163328.GA3562@infradead.org>
References: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
 <20170926042421.GP10955@dastard> <CAOQ4uxhybgUmfk_voNxgx+NVT2JabKdcgtmKxSSGRF5LS+_C+g@mail.gmail.com>
 <20171005163328.GA3562@infradead.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 10 Oct 2017 11:16:03 +0200
Message-ID: <CAOi1vP8e=jPSbhPSUBZ58g-n8rFmjkUvNy3fYxiQDf9kard4jw@mail.gmail.com>
Subject: Re: false positive lockdep splat with loop device
Content-Type: multipart/mixed; boundary="001a11474bdca46d22055b2dc12c"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Byungchul Park <byungchul.park@lge.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

--001a11474bdca46d22055b2dc12c
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 5, 2017 at 6:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Does the patch below fix the warning for you?
>
> --
> From 28aae7104425433d39e6142adcd5b88dc5b0ad5f Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 5 Oct 2017 18:31:02 +0200
> Subject: block: use DECLARE_COMPLETION_ONSTACK in submit_bio_wait
>
> This way we get our lockdep annotations right in case multiple layers
> in the stack use submit_bio_wait.
>
> It also happens to simplify the code by getting rid of the submit_bio_ret
> structure.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 8338304ea256..4e18e959fc0a 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -917,17 +917,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  }
>  EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
>
> -struct submit_bio_ret {
> -       struct completion event;
> -       int error;
> -};
> -
>  static void submit_bio_wait_endio(struct bio *bio)
>  {
> -       struct submit_bio_ret *ret = bio->bi_private;
> -
> -       ret->error = blk_status_to_errno(bio->bi_status);
> -       complete(&ret->event);
> +       complete(bio->bi_private);
>  }
>
>  /**
> @@ -943,16 +935,15 @@ static void submit_bio_wait_endio(struct bio *bio)
>   */
>  int submit_bio_wait(struct bio *bio)
>  {
> -       struct submit_bio_ret ret;
> +       DECLARE_COMPLETION_ONSTACK(done);
>
> -       init_completion(&ret.event);
> -       bio->bi_private = &ret;
> +       bio->bi_private = &done;
>         bio->bi_end_io = submit_bio_wait_endio;
>         bio->bi_opf |= REQ_SYNC;
>         submit_bio(bio);
> -       wait_for_completion_io(&ret.event);
> +       wait_for_completion_io(&done);
>
> -       return ret.error;
> +       return blk_status_to_errno(bio->bi_status);
>  }
>  EXPORT_SYMBOL(submit_bio_wait);

No, it doesn't -- the splat is a little bit more complicated, but
fundamentally the same thing.

Thanks,

                Ilya

--001a11474bdca46d22055b2dc12c
Content-Type: text/plain; charset="US-ASCII"; name="pre.txt"
Content-Disposition: attachment; filename="pre.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j8le4v7a0

cnVuIGZzdGVzdHMgc2hhcmVkLzI5OCBhdCAyMDE3LTEwLTA5IDE2OjU0OjQ1Cgo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KV0FSTklORzogcG9z
c2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVjdGVkCjQuMTQuMC1yYzQtY2Vw
aC1nMDcyMWE2N2ZhNDhmICMxIFRhaW50ZWQ6IEcgICAgICAgIFcgICAgICAKLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCmxvb3AwLzIzMTY2IGlz
IHRyeWluZyB0byBhY3F1aXJlIGxvY2s6CiAoJmVpLT5pX2RhdGFfc2VtKXsrKysrfSwgYXQ6IFs8
ZmZmZmZmZmZhNjM0MDIyNj5dIGV4dDRfcHVuY2hfaG9sZSsweDNiNi8weDU3MAoKYnV0IG5vdyBp
biByZWxlYXNlIGNvbnRleHQgb2YgYSBjcm9zc2xvY2sgYWNxdWlyZWQgYXQgdGhlIGZvbGxvd2lu
ZzoKICgoY29tcGxldGUpJnJldC5ldmVudCl7Ky4rLn0sIGF0OiBbPGZmZmZmZmZmYTY0NWM3YWI+
XSBzdWJtaXRfYmlvX3dhaXQrMHg4Yi8weGIwCgp3aGljaCBsb2NrIGFscmVhZHkgZGVwZW5kcyBv
biB0aGUgbmV3IGxvY2suCgoKdGhlIGV4aXN0aW5nIGRlcGVuZGVuY3kgY2hhaW4gKGluIHJldmVy
c2Ugb3JkZXIpIGlzOgoKLT4gIzEgKChjb21wbGV0ZSkmcmV0LmV2ZW50KXsrLisufToKICAgICAg
IF9fbG9ja19hY3F1aXJlKzB4MTExZi8weDExNTAKICAgICAgIGxvY2tfYWNxdWlyZSsweGVkLzB4
MWUwCiAgICAgICB3YWl0X2Zvcl9jb21wbGV0aW9uX2lvKzB4NTMvMHgxYjAKICAgICAgIHN1Ym1p
dF9iaW9fd2FpdCsweDhiLzB4YjAKICAgICAgIGJsa2Rldl9pc3N1ZV96ZXJvb3V0KzB4Y2YvMHgx
YjAKICAgICAgIGV4dDRfaXNzdWVfemVyb291dCsweDQ0LzB4NjAKICAgICAgIGV4dDRfZXh0X3pl
cm9vdXQrMHgyZi8weDQwCiAgICAgICBleHQ0X2V4dF9jb252ZXJ0X3RvX2luaXRpYWxpemVkKzB4
NmVlLzB4N2EwCiAgICAgICBleHQ0X2V4dF9tYXBfYmxvY2tzKzB4MTUxZC8weDE2MjAKICAgICAg
IGV4dDRfbWFwX2Jsb2NrcysweDE0Zi8weDViMAogICAgICAgZXh0NF93cml0ZXBhZ2VzKzB4YTRh
LzB4MTFlMAogICAgICAgZG9fd3JpdGVwYWdlcysweDFjLzB4ODAKICAgICAgIF9fZmlsZW1hcF9m
ZGF0YXdyaXRlX3JhbmdlKzB4YWEvMHhlMAogICAgICAgZmlsZV93cml0ZV9hbmRfd2FpdF9yYW5n
ZSsweDM5LzB4YTAKICAgICAgIGV4dDRfc3luY19maWxlKzB4YWUvMHg1ODAKICAgICAgIHZmc19m
c3luY19yYW5nZSsweDRiLzB4YjAKICAgICAgIGRvX2ZzeW5jKzB4M2QvMHg3MAogICAgICAgU3lT
X2ZzeW5jKzB4MTAvMHgyMAogICAgICAgZW50cnlfU1lTQ0FMTF82NF9mYXN0cGF0aCsweDIzLzB4
YzIKCi0+ICMwICgmZWktPmlfZGF0YV9zZW0peysrKyt9OgogICAgICAgZG93bl93cml0ZSsweDQw
LzB4NzAKICAgICAgIGV4dDRfcHVuY2hfaG9sZSsweDNiNi8weDU3MAogICAgICAgZXh0NF9mYWxs
b2NhdGUrMHgxOWQvMHhiMjAKICAgICAgIGxvb3BfcXVldWVfd29yaysweGQ3LzB4OWIwCiAgICAg
ICBrdGhyZWFkX3dvcmtlcl9mbisweGJmLzB4MjAwCgpvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVs
cCB1cyBkZWJ1ZyB0aGlzOgoKIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvIGJ5IGNy
b3NzbG9jazoKCiAgICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBDUFUxCiAgICAgICAtLS0t
ICAgICAgICAgICAgICAgICAgICAtLS0tCiAgbG9jaygmZWktPmlfZGF0YV9zZW0pOwogIGxvY2so
KGNvbXBsZXRlKSZyZXQuZXZlbnQpOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9j
aygmZWktPmlfZGF0YV9zZW0pOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5sb2Nr
KChjb21wbGV0ZSkmcmV0LmV2ZW50KTsKCiAqKiogREVBRExPQ0sgKioqCgoxIGxvY2sgaGVsZCBi
eSBsb29wMC8yMzE2NjoKICMwOiAgKCZ4LT53YWl0IzE3KXsuLi0ufSwgYXQ6IFs8ZmZmZmZmZmZh
NjBkNjc4ZD5dIGNvbXBsZXRlKzB4MWQvMHg2MAoKc3RhY2sgYmFja3RyYWNlOgpDUFU6IDAgUElE
OiAyMzE2NiBDb21tOiBsb29wMCBUYWludGVkOiBHICAgICAgICBXICAgICAgIDQuMTQuMC1yYzQt
Y2VwaC1nMDcyMWE2N2ZhNDhmICMxCkhhcmR3YXJlIG5hbWU6IFN1cGVybWljcm8gWDhTSUwvWDhT
SUwsIEJJT1MgMS4wYyAwMi8yNS8yMDEwCkNhbGwgVHJhY2U6CiBkdW1wX3N0YWNrKzB4ODUvMHhj
NwogcHJpbnRfY2lyY3VsYXJfYnVnKzB4MWViLzB4MmUwCiA/IHByaW50X2Jmc19idWcrMHg0MC8w
eDQwCiBjaGVja19wcmV2X2FkZCsweDM5Ni8weDdlMAogPyBqYmQyX2pvdXJuYWxfc3RvcCsweGQw
LzB4NGQwCiBsb2NrX2NvbW1pdF9jcm9zc2xvY2srMHgzZGIvMHg1ZTAKID8gbG9ja19jb21taXRf
Y3Jvc3Nsb2NrKzB4M2RiLzB4NWUwCiBjb21wbGV0ZSsweDI5LzB4NjAKIHN1Ym1pdF9iaW9fd2Fp
dF9lbmRpbysweDI1LzB4MzAKIGJpb19lbmRpbysweDlmLzB4MWUwCiBibGtfdXBkYXRlX3JlcXVl
c3QrMHhjNC8weDNjMAogYmxrX21xX2VuZF9yZXF1ZXN0KzB4MWUvMHg3MAogbG9fY29tcGxldGVf
cnErMHgzMC8weDgwCiBfX2Jsa19tcV9jb21wbGV0ZV9yZXF1ZXN0KzB4YTMvMHgxNjAKIGJsa19t
cV9jb21wbGV0ZV9yZXF1ZXN0KzB4MTYvMHgyMAogbG9vcF9xdWV1ZV93b3JrKzB4NWYvMHg5YjAK
ID8gZmluZF9oZWxkX2xvY2srMHgzOS8weGIwCiA/IGt0aHJlYWRfd29ya2VyX2ZuKzB4OWMvMHgy
MDAKID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4MTFmLzB4MTkwCiBrdGhyZWFkX3dvcmtl
cl9mbisweGJmLzB4MjAwCiBsb29wX2t0aHJlYWRfd29ya2VyX2ZuKzB4MWUvMHgyMAoga3RocmVh
ZCsweDE1Mi8weDE5MAogPyBsb29wX2dldF9zdGF0dXM2NCsweDkwLzB4OTAKID8ga3RocmVhZF9z
dG9wKzB4MmEwLzB4MmEwCiByZXRfZnJvbV9mb3JrKzB4MmEvMHg0MAo=
--001a11474bdca46d22055b2dc12c
Content-Type: text/plain; charset="US-ASCII"; name="post.txt"
Content-Disposition: attachment; filename="post.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j8le50cj1

cnVuIGZzdGVzdHMgc2hhcmVkLzI5OCBhdCAyMDE3LTEwLTA5IDIwOjM4OjUwCgo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KV0FSTklORzogcG9z
c2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVjdGVkCjQuMTQuMC1yYzQtY2Vw
aC1nYzllZDliY2IwMTIxICMxIE5vdCB0YWludGVkCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpsb29wMC8xNTQyMyBpcyB0cnlpbmcgdG8gYWNx
dWlyZSBsb2NrOgogKGpiZDJfaGFuZGxlKXsrKysrfSwgYXQ6IFs8ZmZmZmZmZmZiZDM3YjY5ND5d
IHN0YXJ0X3RoaXNfaGFuZGxlKzB4MTA0LzB4NDUwCgpidXQgbm93IGluIHJlbGVhc2UgY29udGV4
dCBvZiBhIGNyb3NzbG9jayBhY3F1aXJlZCBhdCB0aGUgZm9sbG93aW5nOgogKChjb21wbGV0ZSkm
ZG9uZSMzKXsrLisufSwgYXQ6IFs8ZmZmZmZmZmZiZDQ1Yzc5Yj5dIHN1Ym1pdF9iaW9fd2FpdCsw
eDhiLzB4YzAKCndoaWNoIGxvY2sgYWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KCgp0
aGUgZXhpc3RpbmcgZGVwZW5kZW5jeSBjaGFpbiAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6CgotPiAj
MiAoKGNvbXBsZXRlKSZkb25lIzMpeysuKy59OgogICAgICAgX19sb2NrX2FjcXVpcmUrMHgxMTFm
LzB4MTE1MAogICAgICAgbG9ja19hY3F1aXJlKzB4ZWQvMHgxZTAKICAgICAgIHdhaXRfZm9yX2Nv
bXBsZXRpb25faW8rMHg1My8weDFiMAogICAgICAgc3VibWl0X2Jpb193YWl0KzB4OGIvMHhjMAog
ICAgICAgYmxrZGV2X2lzc3VlX3plcm9vdXQrMHhjZi8weDFiMAogICAgICAgZXh0NF9pbml0X2lu
b2RlX3RhYmxlKzB4MTUzLzB4MzM5CiAgICAgICBleHQ0X2xhenlpbml0X3RocmVhZCsweDJiYy8w
eDNkMAogICAgICAga3RocmVhZCsweDE1Mi8weDE5MAogICAgICAgcmV0X2Zyb21fZm9yaysweDJh
LzB4NDAKCi0+ICMxICgmbWV0YV9ncm91cF9pbmZvW2ldLT5hbGxvY19zZW0peysrKyt9OgogICAg
ICAgX19sb2NrX2FjcXVpcmUrMHgxMTFmLzB4MTE1MAogICAgICAgbG9ja19hY3F1aXJlKzB4ZWQv
MHgxZTAKICAgICAgIGRvd25fcmVhZCsweDQzLzB4NzAKICAgICAgIF9fZXh0NF9uZXdfaW5vZGUr
MHhjNGEvMHgxNDcwCiAgICAgICBleHQ0X2NyZWF0ZSsweDEwMy8weDE5MAogICAgICAgbG9va3Vw
X29wZW4rMHg3OGEvMHg4ODAKICAgICAgIHBhdGhfb3BlbmF0KzB4M2MwLzB4YWQwCiAgICAgICBk
b19maWxwX29wZW4rMHg4YS8weGYwCiAgICAgICBkb19zeXNfb3BlbisweDExYi8weDFmMAogICAg
ICAgU3lTX29wZW4rMHgxZS8weDIwCiAgICAgICBlbnRyeV9TWVNDQUxMXzY0X2Zhc3RwYXRoKzB4
MjMvMHhjMgoKLT4gIzAgKGpiZDJfaGFuZGxlKXsrKysrfToKICAgICAgIHN0YXJ0X3RoaXNfaGFu
ZGxlKzB4MTY3LzB4NDUwCiAgICAgICBqYmQyX19qb3VybmFsX3N0YXJ0KzB4ZGIvMHgyYjAKICAg
ICAgIF9fZXh0NF9qb3VybmFsX3N0YXJ0X3NiKzB4ODkvMHgxZTAKICAgICAgIGV4dDRfcHVuY2hf
aG9sZSsweDIyOS8weDU3MAogICAgICAgZXh0NF9mYWxsb2NhdGUrMHgxOWQvMHhiMjAKCm90aGVy
IGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6CgpDaGFpbiBleGlzdHMgb2Y6CiAg
amJkMl9oYW5kbGUgLS0+ICZtZXRhX2dyb3VwX2luZm9baV0tPmFsbG9jX3NlbSAtLT4gKGNvbXBs
ZXRlKSZkb25lIzMKCiBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJpbyBieSBjcm9zc2xv
Y2s6CgogICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgQ1BVMQogICAgICAgLS0tLSAgICAg
ICAgICAgICAgICAgICAgLS0tLQogIGxvY2soJm1ldGFfZ3JvdXBfaW5mb1tpXS0+YWxsb2Nfc2Vt
KTsKICBsb2NrKChjb21wbGV0ZSkmZG9uZSMzKTsKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGxvY2soamJkMl9oYW5kbGUpOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5s
b2NrKChjb21wbGV0ZSkmZG9uZSMzKTsKCiAqKiogREVBRExPQ0sgKioqCgoxIGxvY2sgaGVsZCBi
eSBsb29wMC8xNTQyMzoKICMwOiAgKCZ4LT53YWl0IzE3KXsuLi0ufSwgYXQ6IFs8ZmZmZmZmZmZi
ZDBkNjc4ZD5dIGNvbXBsZXRlKzB4MWQvMHg2MAoKc3RhY2sgYmFja3RyYWNlOgpDUFU6IDEgUElE
OiAxNTQyMyBDb21tOiBsb29wMCBOb3QgdGFpbnRlZCA0LjE0LjAtcmM0LWNlcGgtZ2M5ZWQ5YmNi
MDEyMSAjMQpIYXJkd2FyZSBuYW1lOiBTdXBlcm1pY3JvIFg4U0lML1g4U0lMLCBCSU9TIDEuMGMg
MDIvMjUvMjAxMApDYWxsIFRyYWNlOgogZHVtcF9zdGFjaysweDg1LzB4YzcKIHByaW50X2NpcmN1
bGFyX2J1ZysweDFlYi8weDJlMAogPyBwcmludF9iZnNfYnVnKzB4NDAvMHg0MAogY2hlY2tfcHJl
dl9hZGQrMHgzOTYvMHg3ZTAKID8gX19sb2NrX2FjcXVpcmUrMHg3MDUvMHgxMTUwCiBsb2NrX2Nv
bW1pdF9jcm9zc2xvY2srMHgzZGIvMHg1ZTAKID8gbG9ja19jb21taXRfY3Jvc3Nsb2NrKzB4M2Ri
LzB4NWUwCiBjb21wbGV0ZSsweDI5LzB4NjAKIHN1Ym1pdF9iaW9fd2FpdF9lbmRpbysweDEyLzB4
MjAKIGJpb19lbmRpbysweDlmLzB4MWUwCiBibGtfdXBkYXRlX3JlcXVlc3QrMHhjNC8weDNjMAog
YmxrX21xX2VuZF9yZXF1ZXN0KzB4MWUvMHg3MAogbG9fY29tcGxldGVfcnErMHgzMC8weDgwCiBf
X2Jsa19tcV9jb21wbGV0ZV9yZXF1ZXN0KzB4YTMvMHgxNjAKIGJsa19tcV9jb21wbGV0ZV9yZXF1
ZXN0KzB4MTYvMHgyMAogbG9vcF9xdWV1ZV93b3JrKzB4NWYvMHg5YjAKID8gZmluZF9oZWxkX2xv
Y2srMHgzOS8weGIwCiA/IGt0aHJlYWRfd29ya2VyX2ZuKzB4OWMvMHgyMDAKID8gdHJhY2VfaGFy
ZGlycXNfb25fY2FsbGVyKzB4MTFmLzB4MTkwCiBrdGhyZWFkX3dvcmtlcl9mbisweGJmLzB4MjAw
CiBsb29wX2t0aHJlYWRfd29ya2VyX2ZuKzB4MWUvMHgyMAoga3RocmVhZCsweDE1Mi8weDE5MAog
PyBsb29wX2dldF9zdGF0dXM2NCsweDkwLzB4OTAKID8ga3RocmVhZF9zdG9wKzB4MmEwLzB4MmEw
CiByZXRfZnJvbV9mb3JrKzB4MmEvMHg0MAo=
--001a11474bdca46d22055b2dc12c--
