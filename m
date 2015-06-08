Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42BA27F7D
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 16:56:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88D2AAC005
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 14:56:17 -0700 (PDT)
Received: from mail-qc0-f181.google.com (mail-qc0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	pEZLAqbwMYKdZ5Cz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jun 2015 14:56:11 -0700 (PDT)
Received: by qcej9 with SMTP id j9so158532qce.1
	for <xfs@oss.sgi.com>; Mon, 08 Jun 2015 14:56:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABppvi7ccK_QVubBhG18P6Xp-xXirUHQc+Wd4+EdTStLPqbQRg@mail.gmail.com>
References: <CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard> <20150604012530.GG9143@dastard>
	<20150604020339.GI9143@dastard> <20150604062337.GK9143@dastard>
	<CABppvi5wNHA18nY497YK0fj4GU+3VLC8VntQ1JKNDR6EErrKxg@mail.gmail.com>
	<CABppvi7ccK_QVubBhG18P6Xp-xXirUHQc+Wd4+EdTStLPqbQRg@mail.gmail.com>
Date: Mon, 8 Jun 2015 14:56:10 -0700
Message-ID: <CABppvi5K1CZgHqbJqA_MhwnL76QQ77Lkc2vA4C0HPgMx50rn3A@mail.gmail.com>
Subject: Re: XFS Syncd
From: Shrinand Javadekar <shrinand@maginatics.com>
Content-Type: multipart/mixed; boundary=001a11c1635eb7430e051808b52f
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

--001a11c1635eb7430e051808b52f
Content-Type: text/plain; charset=UTF-8

I gave this another shot after understanding it better. I now have a
version that doesn't crash. I'm attaching the diff and the new
xfs_buf.c file.
However, in the new version the io_list list doesn't get populated at
all in __xfs_buf_delwri_submit(). I haven't completely familiarized
myself with what callers do with this list. Callers initialize this
list and send a pointer to __xfs_buf_delwri_submit() and expect a
populated list back.

Nonetheless, I ran my experiments after building and inserting the XFS
module with this change. Strangely enough, I see the performance going
down by ~25% compared to the original XFS module.


On Fri, Jun 5, 2015 at 10:31 AM, Shrinand Javadekar
<shrinand@maginatics.com> wrote:
> The file xfs_buf.c seems to have gone through a few revisions. I tried
> to understand the code and make the changes in the 3.16.0 kernel but
> it didn't quite work out. XFS crashed while unmounting the disks.
>
> On Thu, Jun 4, 2015 at 5:59 PM, Shrinand Javadekar
> <shrinand@maginatics.com> wrote:
>> Dave,
>>
>> I believe this code is slightly different from the one I have (kernel
>> v3.16.0). Can you give me a patch for kernel v3.16.0? I have a working
>> setup to try this out.
>>
>> http://lxr.free-electrons.com/source/fs/xfs/xfs_buf.c?v=3.16
>>
>> Thanks in advance.
>> -Shri
>>
>>
>> On Wed, Jun 3, 2015 at 11:23 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Thu, Jun 04, 2015 at 12:03:39PM +1000, Dave Chinner wrote:
>>>> Fixing this requires a tweak to the algorithm in
>>>> __xfs_buf_delwri_submit() so that we don't lock an entire list of
>>>> thousands of IOs before starting submission. In the mean time,
>>>> reducing the number of AGs will reduce the impact of this because
>>>> the delayed write submission code will skip buffers that are already
>>>> locked or pinned in memory, and hence an AG under modification at
>>>> the time submission occurs will be skipped by the delwri code.
>>>
>>> You might like to try the patch below on a test machine to see if
>>> it helps with the problem.
>>>
>>> Cheers,
>>>
>>> Dave.
>>> --
>>> Dave Chinner
>>> david@fromorbit.com
>>>
>>> xfs: reduce lock hold times in buffer writeback
>>>
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> ---
>>>  fs/xfs/xfs_buf.c | 80 ++++++++++++++++++++++++++++++++++++++++++--------------
>>>  1 file changed, 61 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>>> index bbe4e9e..8d2cc36 100644
>>> --- a/fs/xfs/xfs_buf.c
>>> +++ b/fs/xfs/xfs_buf.c
>>> @@ -1768,15 +1768,63 @@ xfs_buf_cmp(
>>>         return 0;
>>>  }
>>>
>>> +static void
>>> +xfs_buf_delwri_submit_buffers(
>>> +       struct list_head        *buffer_list,
>>> +       struct list_head        *io_list,
>>> +       bool                    wait)
>>> +{
>>> +       struct xfs_buf          *bp, *n;
>>> +       struct blk_plug         plug;
>>> +
>>> +       blk_start_plug(&plug);
>>> +       list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>>> +               bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC |
>>> +                                 XBF_WRITE_FAIL);
>>> +               bp->b_flags |= XBF_WRITE | XBF_ASYNC;
>>> +
>>> +               /*
>>> +                * We do all IO submission async. This means if we need
>>> +                * to wait for IO completion we need to take an extra
>>> +                * reference so the buffer is still valid on the other
>>> +                * side. We need to move the buffer onto the io_list
>>> +                * at this point so the caller can still access it.
>>> +                */
>>> +               if (wait) {
>>> +                       xfs_buf_hold(bp);
>>> +                       list_move_tail(&bp->b_list, io_list);
>>> +               } else
>>> +                       list_del_init(&bp->b_list);
>>> +
>>> +               xfs_buf_submit(bp);
>>> +       }
>>> +       blk_finish_plug(&plug);
>>> +}
>>> +
>>> +/*
>>> + * submit buffers for write.
>>> + *
>>> + * When we have a large buffer list, we do not want to hold all the buffers
>>> + * locked while we block on the request queue waiting for IO dispatch. To avoid
>>> + * this problem, we lock and submit buffers in groups of 50, thereby minimising
>>> + * the lock hold times for lists which may contain thousands of objects.
>>> + *
>>> + * To do this, we sort the buffer list before we walk the list to lock and
>>> + * submit buffers, and we plug and unplug around each group of buffers we
>>> + * submit.
>>> + */
>>>  static int
>>>  __xfs_buf_delwri_submit(
>>>         struct list_head        *buffer_list,
>>>         struct list_head        *io_list,
>>>         bool                    wait)
>>>  {
>>> -       struct blk_plug         plug;
>>>         struct xfs_buf          *bp, *n;
>>> +       LIST_HEAD               (submit_list);
>>>         int                     pinned = 0;
>>> +       int                     count = 0;
>>> +
>>> +       list_sort(NULL, buffer_list, xfs_buf_cmp);
>>>
>>>         list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>>>                 if (!wait) {
>>> @@ -1802,30 +1850,24 @@ __xfs_buf_delwri_submit(
>>>                         continue;
>>>                 }
>>>
>>> -               list_move_tail(&bp->b_list, io_list);
>>> +               list_move_tail(&bp->b_list, &submit_list);
>>>                 trace_xfs_buf_delwri_split(bp, _RET_IP_);
>>> -       }
>>> -
>>> -       list_sort(NULL, io_list, xfs_buf_cmp);
>>> -
>>> -       blk_start_plug(&plug);
>>> -       list_for_each_entry_safe(bp, n, io_list, b_list) {
>>> -               bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
>>> -               bp->b_flags |= XBF_WRITE | XBF_ASYNC;
>>>
>>>                 /*
>>> -                * we do all Io submission async. This means if we need to wait
>>> -                * for IO completion we need to take an extra reference so the
>>> -                * buffer is still valid on the other side.
>>> +                * We do small batches of  IO submission to minimise lock hold
>>> +                * time and unnecessary writeback of buffers that are hot and
>>> +                * would otherwise be relogged and hence not require immediate
>>> +                * writeback.
>>>                  */
>>> -               if (wait)
>>> -                       xfs_buf_hold(bp);
>>> -               else
>>> -                       list_del_init(&bp->b_list);
>>> +               if (count++ < 50)
>>> +                       continue;
>>>
>>> -               xfs_buf_submit(bp);
>>> +               xfs_buf_delwri_submit_buffers(&submit_list, io_list, wait);
>>> +               count = 0;
>>>         }
>>> -       blk_finish_plug(&plug);
>>> +
>>> +       if (!list_empty(&submit_list))
>>> +               xfs_buf_delwri_submit_buffers(&submit_list, io_list, wait);
>>>
>>>         return pinned;
>>>  }

--001a11c1635eb7430e051808b52f
Content-Type: application/octet-stream; name=xfs_diff
Content-Disposition: attachment; filename=xfs_diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iaodw78o0

MTc1OGExNzU5LDE3ODIKPiAKPiBzdGF0aWMgdm9pZAo+IHhmc19idWZfZGVsd3JpX3N1Ym1pdF9i
dWZmZXJzKAo+ICAgICAgICBzdHJ1Y3QgbGlzdF9oZWFkICAgICAgICAqYnVmZmVyX2xpc3QsCj4g
ICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgIHdhaXQpCj4gewo+ICAgICAgICBzdHJ1Y3Qg
eGZzX2J1ZiAgICAgICAgICAqYnAsICpuOwo+ICAgICAgICBzdHJ1Y3QgYmxrX3BsdWcgICAgICAg
ICBwbHVnOwo+IAo+ICAgICAgICBibGtfc3RhcnRfcGx1ZygmcGx1Zyk7Cj4gICAgICAgIGxpc3Rf
Zm9yX2VhY2hfZW50cnlfc2FmZShicCwgbiwgYnVmZmVyX2xpc3QsIGJfbGlzdCkgewo+ICAgICAg
ICAgICAgYnAtPmJfZmxhZ3MgJj0gfihfWEJGX0RFTFdSSV9RIHwgWEJGX0FTWU5DIHwgWEJGX1dS
SVRFX0ZBSUwpOwo+ICAJICAgYnAtPmJfZmxhZ3MgfD0gWEJGX1dSSVRFOwo+IAo+IAkgICBpZiAo
IXdhaXQpIHsKPiAgCSAgICAgICBicC0+Yl9mbGFncyB8PSBYQkZfQVNZTkM7Cj4gCSAgICAgICBs
aXN0X2RlbF9pbml0KCZicC0+Yl9saXN0KTsKPiAJICAgfQo+ICAgICAgICAgICAgeGZzX2Jkc3Ry
YXRfY2IoYnApOwo+IAl9Cj4gCWJsa19maW5pc2hfcGx1ZygmcGx1Zyk7Cj4gfQo+IAo+IAoxNzY1
ZDE3ODgKPCAJc3RydWN0IGJsa19wbHVnCQlwbHVnOwoxNzY3YTE3OTEsMTc5NAo+ICAgICAgICAg
TElTVF9IRUFEICAgICAgICAgICAgICAgKHN1Ym1pdF9saXN0KTsKPiAgICAgICAgIGludCAgICAg
ICAgICAgICAgICAgICAgIGNvdW50ID0gMDsKPiAKPiAgICAgICAgIGxpc3Rfc29ydChOVUxMLCBi
dWZmZXJfbGlzdCwgeGZzX2J1Zl9jbXApOwoxNzkzYzE4MjAsMTgyMQo8IAkJbGlzdF9tb3ZlX3Rh
aWwoJmJwLT5iX2xpc3QsIGlvX2xpc3QpOwotLS0KPiAJCS8vbGlzdF9tb3ZlX3RhaWwoJmJwLT5i
X2xpc3QsIGlvX2xpc3QpOwo+ICAgICAgICAgICAgICAgICBsaXN0X21vdmVfdGFpbCgmYnAtPmJf
bGlzdCwgJnN1Ym1pdF9saXN0KTsKMTc5NWMxODIzLDE4MjUKPCAJfQotLS0KPiAgICAgICAgICAg
ICAgICAgaWYgKGNvdW50KysgPCA1MCkgewo+ICAgICAgICAgICAgICAgICAgICAgY29udGludWU7
Cj4gICAgICAgICAgICAgICAgIH0KMTc5N2MxODI3LDE4MjkKPCAJbGlzdF9zb3J0KE5VTEwsIGlv
X2xpc3QsIHhmc19idWZfY21wKTsKLS0tCj4gICAgICAgICAgICAgICAgIHhmc19idWZfZGVsd3Jp
X3N1Ym1pdF9idWZmZXJzKCZzdWJtaXRfbGlzdCwgd2FpdCk7Cj4gICAgICAgICAgICAgICAgIGNv
dW50ID0gMDsKPiAJfQoxNzk5LDE4MDJjMTgzMQo8IAlibGtfc3RhcnRfcGx1ZygmcGx1Zyk7Cjwg
CWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShicCwgbiwgaW9fbGlzdCwgYl9saXN0KSB7CjwgCQli
cC0+Yl9mbGFncyAmPSB+KF9YQkZfREVMV1JJX1EgfCBYQkZfQVNZTkMgfCBYQkZfV1JJVEVfRkFJ
TCk7CjwgCQlicC0+Yl9mbGFncyB8PSBYQkZfV1JJVEU7Ci0tLQo+IAkvLyBsaXN0X3NvcnQoTlVM
TCwgaW9fbGlzdCwgeGZzX2J1Zl9jbXApOwoxODA0LDE4MTBjMTgzMywxODM1CjwgCQlpZiAoIXdh
aXQpIHsKPCAJCQlicC0+Yl9mbGFncyB8PSBYQkZfQVNZTkM7CjwgCQkJbGlzdF9kZWxfaW5pdCgm
YnAtPmJfbGlzdCk7CjwgCQl9CjwgCQl4ZnNfYmRzdHJhdF9jYihicCk7CjwgCX0KPCAJYmxrX2Zp
bmlzaF9wbHVnKCZwbHVnKTsKLS0tCj4gICAgICAgICBpZiAoIWxpc3RfZW1wdHkoJnN1Ym1pdF9s
aXN0KSkgewo+ICAgICAgICAgICAgIHhmc19idWZfZGVsd3JpX3N1Ym1pdF9idWZmZXJzKCZzdWJt
aXRfbGlzdCwgd2FpdCk7Cj4gICAgICAgICB9Cg==
--001a11c1635eb7430e051808b52f
Content-Type: text/x-csrc; charset=US-ASCII; name="xfs_buf.c"
Content-Disposition: attachment; filename="xfs_buf.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iaodwaf91

LyoKICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMDYgU2lsaWNvbiBHcmFwaGljcywgSW5jLgogKiBB
bGwgUmlnaHRzIFJlc2VydmVkLgogKgogKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsg
eW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCiAqIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVy
bXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzCiAqIHB1Ymxpc2hlZCBieSB0
aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLgogKgogKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJp
YnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3b3VsZCBiZSB1c2VmdWwsCiAqIGJ1dCBXSVRIT1VU
IEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCiAqIE1F
UkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0
aGUKICogR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KICoKICog
WW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UKICogYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdGhlIEZy
ZWUgU29mdHdhcmUgRm91bmRhdGlvbiwKICogSW5jLiwgIDUxIEZyYW5rbGluIFN0LCBGaWZ0aCBG
bG9vciwgQm9zdG9uLCBNQSAgMDIxMTAtMTMwMSAgVVNBCiAqLwojaW5jbHVkZSAieGZzLmgiCiNp
bmNsdWRlIDxsaW51eC9zdGRkZWYuaD4KI2luY2x1ZGUgPGxpbnV4L2Vycm5vLmg+CiNpbmNsdWRl
IDxsaW51eC9nZnAuaD4KI2luY2x1ZGUgPGxpbnV4L3BhZ2VtYXAuaD4KI2luY2x1ZGUgPGxpbnV4
L2luaXQuaD4KI2luY2x1ZGUgPGxpbnV4L3ZtYWxsb2MuaD4KI2luY2x1ZGUgPGxpbnV4L2Jpby5o
PgojaW5jbHVkZSA8bGludXgvc3lzY3RsLmg+CiNpbmNsdWRlIDxsaW51eC9wcm9jX2ZzLmg+CiNp
bmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KI2luY2x1ZGUgPGxpbnV4L3BlcmNwdS5oPgojaW5j
bHVkZSA8bGludXgvYmxrZGV2Lmg+CiNpbmNsdWRlIDxsaW51eC9oYXNoLmg+CiNpbmNsdWRlIDxs
aW51eC9rdGhyZWFkLmg+CiNpbmNsdWRlIDxsaW51eC9taWdyYXRlLmg+CiNpbmNsdWRlIDxsaW51
eC9iYWNraW5nLWRldi5oPgojaW5jbHVkZSA8bGludXgvZnJlZXplci5oPgoKI2luY2x1ZGUgInhm
c19sb2dfZm9ybWF0LmgiCiNpbmNsdWRlICJ4ZnNfdHJhbnNfcmVzdi5oIgojaW5jbHVkZSAieGZz
X3NiLmgiCiNpbmNsdWRlICJ4ZnNfYWcuaCIKI2luY2x1ZGUgInhmc19tb3VudC5oIgojaW5jbHVk
ZSAieGZzX3RyYWNlLmgiCiNpbmNsdWRlICJ4ZnNfbG9nLmgiCgpzdGF0aWMga21lbV96b25lX3Qg
Knhmc19idWZfem9uZTsKCnN0YXRpYyBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqeGZzbG9nZF93
b3JrcXVldWU7CgojaWZkZWYgWEZTX0JVRl9MT0NLX1RSQUNLSU5HCiMgZGVmaW5lIFhCX1NFVF9P
V05FUihicCkJKChicCktPmJfbGFzdF9ob2xkZXIgPSBjdXJyZW50LT5waWQpCiMgZGVmaW5lIFhC
X0NMRUFSX09XTkVSKGJwKQkoKGJwKS0+Yl9sYXN0X2hvbGRlciA9IC0xKQojIGRlZmluZSBYQl9H
RVRfT1dORVIoYnApCSgoYnApLT5iX2xhc3RfaG9sZGVyKQojZWxzZQojIGRlZmluZSBYQl9TRVRf
T1dORVIoYnApCWRvIHsgfSB3aGlsZSAoMCkKIyBkZWZpbmUgWEJfQ0xFQVJfT1dORVIoYnApCWRv
IHsgfSB3aGlsZSAoMCkKIyBkZWZpbmUgWEJfR0VUX09XTkVSKGJwKQlkbyB7IH0gd2hpbGUgKDAp
CiNlbmRpZgoKI2RlZmluZSB4Yl90b19nZnAoZmxhZ3MpIFwKCSgoKChmbGFncykgJiBYQkZfUkVB
RF9BSEVBRCkgPyBfX0dGUF9OT1JFVFJZIDogR0ZQX05PRlMpIHwgX19HRlBfTk9XQVJOKQoKCnN0
YXRpYyBpbmxpbmUgaW50Cnhmc19idWZfaXNfdm1hcHBlZCgKCXN0cnVjdCB4ZnNfYnVmCSpicCkK
ewoJLyoKCSAqIFJldHVybiB0cnVlIGlmIHRoZSBidWZmZXIgaXMgdm1hcHBlZC4KCSAqCgkgKiBi
X2FkZHIgaXMgbnVsbCBpZiB0aGUgYnVmZmVyIGlzIG5vdCBtYXBwZWQsIGJ1dCB0aGUgY29kZSBp
cyBjbGV2ZXIKCSAqIGVub3VnaCB0byBrbm93IGl0IGRvZXNuJ3QgaGF2ZSB0byBtYXAgYSBzaW5n
bGUgcGFnZSwgc28gdGhlIGNoZWNrIGhhcwoJICogdG8gYmUgYm90aCBmb3IgYl9hZGRyIGFuZCBi
cC0+Yl9wYWdlX2NvdW50ID4gMS4KCSAqLwoJcmV0dXJuIGJwLT5iX2FkZHIgJiYgYnAtPmJfcGFn
ZV9jb3VudCA+IDE7Cn0KCnN0YXRpYyBpbmxpbmUgaW50Cnhmc19idWZfdm1hcF9sZW4oCglzdHJ1
Y3QgeGZzX2J1ZgkqYnApCnsKCXJldHVybiAoYnAtPmJfcGFnZV9jb3VudCAqIFBBR0VfU0laRSkg
LSBicC0+Yl9vZmZzZXQ7Cn0KCi8qCiAqIFdoZW4gd2UgbWFyayBhIGJ1ZmZlciBzdGFsZSwgd2Ug
cmVtb3ZlIHRoZSBidWZmZXIgZnJvbSB0aGUgTFJVIGFuZCBjbGVhciB0aGUKICogYl9scnVfcmVm
IGNvdW50IHNvIHRoYXQgdGhlIGJ1ZmZlciBpcyBmcmVlZCBpbW1lZGlhdGVseSB3aGVuIHRoZSBi
dWZmZXIKICogcmVmZXJlbmNlIGNvdW50IGZhbGxzIHRvIHplcm8uIElmIHRoZSBidWZmZXIgaXMg
YWxyZWFkeSBvbiB0aGUgTFJVLCB3ZSBuZWVkCiAqIHRvIHJlbW92ZSB0aGUgcmVmZXJlbmNlIHRo
YXQgTFJVIGhvbGRzIG9uIHRoZSBidWZmZXIuCiAqCiAqIFRoaXMgcHJldmVudHMgYnVpbGQtdXAg
b2Ygc3RhbGUgYnVmZmVycyBvbiB0aGUgTFJVLgogKi8Kdm9pZAp4ZnNfYnVmX3N0YWxlKAoJc3Ry
dWN0IHhmc19idWYJKmJwKQp7CglBU1NFUlQoeGZzX2J1Zl9pc2xvY2tlZChicCkpOwoKCWJwLT5i
X2ZsYWdzIHw9IFhCRl9TVEFMRTsKCgkvKgoJICogQ2xlYXIgdGhlIGRlbHdyaSBzdGF0dXMgc28g
dGhhdCBhIGRlbHdyaSBxdWV1ZSB3YWxrZXIgd2lsbCBub3QKCSAqIGZsdXNoIHRoaXMgYnVmZmVy
IHRvIGRpc2sgbm93IHRoYXQgaXQgaXMgc3RhbGUuIFRoZSBkZWx3cmkgcXVldWUgaGFzCgkgKiBh
IHJlZmVyZW5jZSB0byB0aGUgYnVmZmVyLCBzbyB0aGlzIGlzIHNhZmUgdG8gZG8uCgkgKi8KCWJw
LT5iX2ZsYWdzICY9IH5fWEJGX0RFTFdSSV9ROwoKCXNwaW5fbG9jaygmYnAtPmJfbG9jayk7Cglh
dG9taWNfc2V0KCZicC0+Yl9scnVfcmVmLCAwKTsKCWlmICghKGJwLT5iX3N0YXRlICYgWEZTX0JT
VEFURV9ESVNQT1NFKSAmJgoJICAgIChsaXN0X2xydV9kZWwoJmJwLT5iX3RhcmdldC0+YnRfbHJ1
LCAmYnAtPmJfbHJ1KSkpCgkJYXRvbWljX2RlYygmYnAtPmJfaG9sZCk7CgoJQVNTRVJUKGF0b21p
Y19yZWFkKCZicC0+Yl9ob2xkKSA+PSAxKTsKCXNwaW5fdW5sb2NrKCZicC0+Yl9sb2NrKTsKfQoK
c3RhdGljIGludAp4ZnNfYnVmX2dldF9tYXBzKAoJc3RydWN0IHhmc19idWYJCSpicCwKCWludAkJ
CW1hcF9jb3VudCkKewoJQVNTRVJUKGJwLT5iX21hcHMgPT0gTlVMTCk7CglicC0+Yl9tYXBfY291
bnQgPSBtYXBfY291bnQ7CgoJaWYgKG1hcF9jb3VudCA9PSAxKSB7CgkJYnAtPmJfbWFwcyA9ICZi
cC0+X19iX21hcDsKCQlyZXR1cm4gMDsKCX0KCglicC0+Yl9tYXBzID0ga21lbV96YWxsb2MobWFw
X2NvdW50ICogc2l6ZW9mKHN0cnVjdCB4ZnNfYnVmX21hcCksCgkJCQlLTV9OT0ZTKTsKCWlmICgh
YnAtPmJfbWFwcykKCQlyZXR1cm4gRU5PTUVNOwoJcmV0dXJuIDA7Cn0KCi8qCiAqCUZyZWVzIGJf
cGFnZXMgaWYgaXQgd2FzIGFsbG9jYXRlZC4KICovCnN0YXRpYyB2b2lkCnhmc19idWZfZnJlZV9t
YXBzKAoJc3RydWN0IHhmc19idWYJKmJwKQp7CglpZiAoYnAtPmJfbWFwcyAhPSAmYnAtPl9fYl9t
YXApIHsKCQlrbWVtX2ZyZWUoYnAtPmJfbWFwcyk7CgkJYnAtPmJfbWFwcyA9IE5VTEw7Cgl9Cn0K
CnN0cnVjdCB4ZnNfYnVmICoKX3hmc19idWZfYWxsb2MoCglzdHJ1Y3QgeGZzX2J1ZnRhcmcJKnRh
cmdldCwKCXN0cnVjdCB4ZnNfYnVmX21hcAkqbWFwLAoJaW50CQkJbm1hcHMsCgl4ZnNfYnVmX2Zs
YWdzX3QJCWZsYWdzKQp7CglzdHJ1Y3QgeGZzX2J1ZgkJKmJwOwoJaW50CQkJZXJyb3I7CglpbnQJ
CQlpOwoKCWJwID0ga21lbV96b25lX3phbGxvYyh4ZnNfYnVmX3pvbmUsIEtNX05PRlMpOwoJaWYg
KHVubGlrZWx5KCFicCkpCgkJcmV0dXJuIE5VTEw7CgoJLyoKCSAqIFdlIGRvbid0IHdhbnQgY2Vy
dGFpbiBmbGFncyB0byBhcHBlYXIgaW4gYl9mbGFncyB1bmxlc3MgdGhleSBhcmUKCSAqIHNwZWNp
ZmljYWxseSBzZXQgYnkgbGF0ZXIgb3BlcmF0aW9ucyBvbiB0aGUgYnVmZmVyLgoJICovCglmbGFn
cyAmPSB+KFhCRl9VTk1BUFBFRCB8IFhCRl9UUllMT0NLIHwgWEJGX0FTWU5DIHwgWEJGX1JFQURf
QUhFQUQpOwoKCWF0b21pY19zZXQoJmJwLT5iX2hvbGQsIDEpOwoJYXRvbWljX3NldCgmYnAtPmJf
bHJ1X3JlZiwgMSk7Cglpbml0X2NvbXBsZXRpb24oJmJwLT5iX2lvd2FpdCk7CglJTklUX0xJU1Rf
SEVBRCgmYnAtPmJfbHJ1KTsKCUlOSVRfTElTVF9IRUFEKCZicC0+Yl9saXN0KTsKCVJCX0NMRUFS
X05PREUoJmJwLT5iX3Jibm9kZSk7CglzZW1hX2luaXQoJmJwLT5iX3NlbWEsIDApOyAvKiBoZWxk
LCBubyB3YWl0ZXJzICovCglzcGluX2xvY2tfaW5pdCgmYnAtPmJfbG9jayk7CglYQl9TRVRfT1dO
RVIoYnApOwoJYnAtPmJfdGFyZ2V0ID0gdGFyZ2V0OwoJYnAtPmJfZmxhZ3MgPSBmbGFnczsKCgkv
KgoJICogU2V0IGxlbmd0aCBhbmQgaW9fbGVuZ3RoIHRvIHRoZSBzYW1lIHZhbHVlIGluaXRpYWxs
eS4KCSAqIEkvTyByb3V0aW5lcyBzaG91bGQgdXNlIGlvX2xlbmd0aCwgd2hpY2ggd2lsbCBiZSB0
aGUgc2FtZSBpbgoJICogbW9zdCBjYXNlcyBidXQgbWF5IGJlIHJlc2V0IChlLmcuIFhGUyByZWNv
dmVyeSkuCgkgKi8KCWVycm9yID0geGZzX2J1Zl9nZXRfbWFwcyhicCwgbm1hcHMpOwoJaWYgKGVy
cm9yKSAgewoJCWttZW1fem9uZV9mcmVlKHhmc19idWZfem9uZSwgYnApOwoJCXJldHVybiBOVUxM
OwoJfQoKCWJwLT5iX2JuID0gbWFwWzBdLmJtX2JuOwoJYnAtPmJfbGVuZ3RoID0gMDsKCWZvciAo
aSA9IDA7IGkgPCBubWFwczsgaSsrKSB7CgkJYnAtPmJfbWFwc1tpXS5ibV9ibiA9IG1hcFtpXS5i
bV9ibjsKCQlicC0+Yl9tYXBzW2ldLmJtX2xlbiA9IG1hcFtpXS5ibV9sZW47CgkJYnAtPmJfbGVu
Z3RoICs9IG1hcFtpXS5ibV9sZW47Cgl9CglicC0+Yl9pb19sZW5ndGggPSBicC0+Yl9sZW5ndGg7
CgoJYXRvbWljX3NldCgmYnAtPmJfcGluX2NvdW50LCAwKTsKCWluaXRfd2FpdHF1ZXVlX2hlYWQo
JmJwLT5iX3dhaXRlcnMpOwoKCVhGU19TVEFUU19JTkMoeGJfY3JlYXRlKTsKCXRyYWNlX3hmc19i
dWZfaW5pdChicCwgX1JFVF9JUF8pOwoKCXJldHVybiBicDsKfQoKLyoKICoJQWxsb2NhdGUgYSBw
YWdlIGFycmF5IGNhcGFibGUgb2YgaG9sZGluZyBhIHNwZWNpZmllZCBudW1iZXIKICoJb2YgcGFn
ZXMsIGFuZCBwb2ludCB0aGUgcGFnZSBidWYgYXQgaXQuCiAqLwpTVEFUSUMgaW50Cl94ZnNfYnVm
X2dldF9wYWdlcygKCXhmc19idWZfdAkJKmJwLAoJaW50CQkJcGFnZV9jb3VudCkKewoJLyogTWFr
ZSBzdXJlIHRoYXQgd2UgaGF2ZSBhIHBhZ2UgbGlzdCAqLwoJaWYgKGJwLT5iX3BhZ2VzID09IE5V
TEwpIHsKCQlicC0+Yl9wYWdlX2NvdW50ID0gcGFnZV9jb3VudDsKCQlpZiAocGFnZV9jb3VudCA8
PSBYQl9QQUdFUykgewoJCQlicC0+Yl9wYWdlcyA9IGJwLT5iX3BhZ2VfYXJyYXk7CgkJfSBlbHNl
IHsKCQkJYnAtPmJfcGFnZXMgPSBrbWVtX2FsbG9jKHNpemVvZihzdHJ1Y3QgcGFnZSAqKSAqCgkJ
CQkJCSBwYWdlX2NvdW50LCBLTV9OT0ZTKTsKCQkJaWYgKGJwLT5iX3BhZ2VzID09IE5VTEwpCgkJ
CQlyZXR1cm4gLUVOT01FTTsKCQl9CgkJbWVtc2V0KGJwLT5iX3BhZ2VzLCAwLCBzaXplb2Yoc3Ry
dWN0IHBhZ2UgKikgKiBwYWdlX2NvdW50KTsKCX0KCXJldHVybiAwOwp9CgovKgogKglGcmVlcyBi
X3BhZ2VzIGlmIGl0IHdhcyBhbGxvY2F0ZWQuCiAqLwpTVEFUSUMgdm9pZApfeGZzX2J1Zl9mcmVl
X3BhZ2VzKAoJeGZzX2J1Zl90CSpicCkKewoJaWYgKGJwLT5iX3BhZ2VzICE9IGJwLT5iX3BhZ2Vf
YXJyYXkpIHsKCQlrbWVtX2ZyZWUoYnAtPmJfcGFnZXMpOwoJCWJwLT5iX3BhZ2VzID0gTlVMTDsK
CX0KfQoKLyoKICoJUmVsZWFzZXMgdGhlIHNwZWNpZmllZCBidWZmZXIuCiAqCiAqIAlUaGUgbW9k
aWZpY2F0aW9uIHN0YXRlIG9mIGFueSBhc3NvY2lhdGVkIHBhZ2VzIGlzIGxlZnQgdW5jaGFuZ2Vk
LgogKiAJVGhlIGJ1ZmZlciBtdXN0IG5vdCBiZSBvbiBhbnkgaGFzaCAtIHVzZSB4ZnNfYnVmX3Jl
bGUgaW5zdGVhZCBmb3IKICogCWhhc2hlZCBhbmQgcmVmY291bnRlZCBidWZmZXJzCiAqLwp2b2lk
Cnhmc19idWZfZnJlZSgKCXhmc19idWZfdAkJKmJwKQp7Cgl0cmFjZV94ZnNfYnVmX2ZyZWUoYnAs
IF9SRVRfSVBfKTsKCglBU1NFUlQobGlzdF9lbXB0eSgmYnAtPmJfbHJ1KSk7CgoJaWYgKGJwLT5i
X2ZsYWdzICYgX1hCRl9QQUdFUykgewoJCXVpbnQJCWk7CgoJCWlmICh4ZnNfYnVmX2lzX3ZtYXBw
ZWQoYnApKQoJCQl2bV91bm1hcF9yYW0oYnAtPmJfYWRkciAtIGJwLT5iX29mZnNldCwKCQkJCQli
cC0+Yl9wYWdlX2NvdW50KTsKCgkJZm9yIChpID0gMDsgaSA8IGJwLT5iX3BhZ2VfY291bnQ7IGkr
KykgewoJCQlzdHJ1Y3QgcGFnZQkqcGFnZSA9IGJwLT5iX3BhZ2VzW2ldOwoKCQkJX19mcmVlX3Bh
Z2UocGFnZSk7CgkJfQoJfSBlbHNlIGlmIChicC0+Yl9mbGFncyAmIF9YQkZfS01FTSkKCQlrbWVt
X2ZyZWUoYnAtPmJfYWRkcik7CglfeGZzX2J1Zl9mcmVlX3BhZ2VzKGJwKTsKCXhmc19idWZfZnJl
ZV9tYXBzKGJwKTsKCWttZW1fem9uZV9mcmVlKHhmc19idWZfem9uZSwgYnApOwp9CgovKgogKiBB
bGxvY2F0ZXMgYWxsIHRoZSBwYWdlcyBmb3IgYnVmZmVyIGluIHF1ZXN0aW9uIGFuZCBidWlsZHMg
aXQncyBwYWdlIGxpc3QuCiAqLwpTVEFUSUMgaW50Cnhmc19idWZfYWxsb2NhdGVfbWVtb3J5KAoJ
eGZzX2J1Zl90CQkqYnAsCgl1aW50CQkJZmxhZ3MpCnsKCXNpemVfdAkJCXNpemU7CglzaXplX3QJ
CQluYnl0ZXMsIG9mZnNldDsKCWdmcF90CQkJZ2ZwX21hc2sgPSB4Yl90b19nZnAoZmxhZ3MpOwoJ
dW5zaWduZWQgc2hvcnQJCXBhZ2VfY291bnQsIGk7Cgl4ZnNfb2ZmX3QJCXN0YXJ0LCBlbmQ7Cglp
bnQJCQllcnJvcjsKCgkvKgoJICogZm9yIGJ1ZmZlcnMgdGhhdCBhcmUgY29udGFpbmVkIHdpdGhp
biBhIHNpbmdsZSBwYWdlLCBqdXN0IGFsbG9jYXRlCgkgKiB0aGUgbWVtb3J5IGZyb20gdGhlIGhl
YXAgLSB0aGVyZSdzIG5vIG5lZWQgZm9yIHRoZSBjb21wbGV4aXR5IG9mCgkgKiBwYWdlIGFycmF5
cyB0byBrZWVwIGFsbG9jYXRpb24gZG93biB0byBvcmRlciAwLgoJICovCglzaXplID0gQkJUT0Io
YnAtPmJfbGVuZ3RoKTsKCWlmIChzaXplIDwgUEFHRV9TSVpFKSB7CgkJYnAtPmJfYWRkciA9IGtt
ZW1fYWxsb2Moc2l6ZSwgS01fTk9GUyk7CgkJaWYgKCFicC0+Yl9hZGRyKSB7CgkJCS8qIGxvdyBt
ZW1vcnkgLSB1c2UgYWxsb2NfcGFnZSBsb29wIGluc3RlYWQgKi8KCQkJZ290byB1c2VfYWxsb2Nf
cGFnZTsKCQl9CgoJCWlmICgoKHVuc2lnbmVkIGxvbmcpKGJwLT5iX2FkZHIgKyBzaXplIC0gMSkg
JiBQQUdFX01BU0spICE9CgkJICAgICgodW5zaWduZWQgbG9uZylicC0+Yl9hZGRyICYgUEFHRV9N
QVNLKSkgewoJCQkvKiBiX2FkZHIgc3BhbnMgdHdvIHBhZ2VzIC0gdXNlIGFsbG9jX3BhZ2UgaW5z
dGVhZCAqLwoJCQlrbWVtX2ZyZWUoYnAtPmJfYWRkcik7CgkJCWJwLT5iX2FkZHIgPSBOVUxMOwoJ
CQlnb3RvIHVzZV9hbGxvY19wYWdlOwoJCX0KCQlicC0+Yl9vZmZzZXQgPSBvZmZzZXRfaW5fcGFn
ZShicC0+Yl9hZGRyKTsKCQlicC0+Yl9wYWdlcyA9IGJwLT5iX3BhZ2VfYXJyYXk7CgkJYnAtPmJf
cGFnZXNbMF0gPSB2aXJ0X3RvX3BhZ2UoYnAtPmJfYWRkcik7CgkJYnAtPmJfcGFnZV9jb3VudCA9
IDE7CgkJYnAtPmJfZmxhZ3MgfD0gX1hCRl9LTUVNOwoJCXJldHVybiAwOwoJfQoKdXNlX2FsbG9j
X3BhZ2U6CglzdGFydCA9IEJCVE9CKGJwLT5iX21hcHNbMF0uYm1fYm4pID4+IFBBR0VfU0hJRlQ7
CgllbmQgPSAoQkJUT0IoYnAtPmJfbWFwc1swXS5ibV9ibiArIGJwLT5iX2xlbmd0aCkgKyBQQUdF
X1NJWkUgLSAxKQoJCQkJCQkJCT4+IFBBR0VfU0hJRlQ7CglwYWdlX2NvdW50ID0gZW5kIC0gc3Rh
cnQ7CgllcnJvciA9IF94ZnNfYnVmX2dldF9wYWdlcyhicCwgcGFnZV9jb3VudCk7CglpZiAodW5s
aWtlbHkoZXJyb3IpKQoJCXJldHVybiBlcnJvcjsKCglvZmZzZXQgPSBicC0+Yl9vZmZzZXQ7Cgli
cC0+Yl9mbGFncyB8PSBfWEJGX1BBR0VTOwoKCWZvciAoaSA9IDA7IGkgPCBicC0+Yl9wYWdlX2Nv
dW50OyBpKyspIHsKCQlzdHJ1Y3QgcGFnZQkqcGFnZTsKCQl1aW50CQlyZXRyaWVzID0gMDsKcmV0
cnk6CgkJcGFnZSA9IGFsbG9jX3BhZ2UoZ2ZwX21hc2spOwoJCWlmICh1bmxpa2VseShwYWdlID09
IE5VTEwpKSB7CgkJCWlmIChmbGFncyAmIFhCRl9SRUFEX0FIRUFEKSB7CgkJCQlicC0+Yl9wYWdl
X2NvdW50ID0gaTsKCQkJCWVycm9yID0gRU5PTUVNOwoJCQkJZ290byBvdXRfZnJlZV9wYWdlczsK
CQkJfQoKCQkJLyoKCQkJICogVGhpcyBjb3VsZCBkZWFkbG9jay4KCQkJICoKCQkJICogQnV0IHVu
dGlsIGFsbCB0aGUgWEZTIGxvd2xldmVsIGNvZGUgaXMgcmV2YW1wZWQgdG8KCQkJICogaGFuZGxl
IGJ1ZmZlciBhbGxvY2F0aW9uIGZhaWx1cmVzIHdlIGNhbid0IGRvIG11Y2guCgkJCSAqLwoJCQlp
ZiAoISgrK3JldHJpZXMgJSAxMDApKQoJCQkJeGZzX2VycihOVUxMLAoJCSJwb3NzaWJsZSBtZW1v
cnkgYWxsb2NhdGlvbiBkZWFkbG9jayBpbiAlcyAobW9kZToweCV4KSIsCgkJCQkJX19mdW5jX18s
IGdmcF9tYXNrKTsKCgkJCVhGU19TVEFUU19JTkMoeGJfcGFnZV9yZXRyaWVzKTsKCQkJY29uZ2Vz
dGlvbl93YWl0KEJMS19SV19BU1lOQywgSFovNTApOwoJCQlnb3RvIHJldHJ5OwoJCX0KCgkJWEZT
X1NUQVRTX0lOQyh4Yl9wYWdlX2ZvdW5kKTsKCgkJbmJ5dGVzID0gbWluX3Qoc2l6ZV90LCBzaXpl
LCBQQUdFX1NJWkUgLSBvZmZzZXQpOwoJCXNpemUgLT0gbmJ5dGVzOwoJCWJwLT5iX3BhZ2VzW2ld
ID0gcGFnZTsKCQlvZmZzZXQgPSAwOwoJfQoJcmV0dXJuIDA7CgpvdXRfZnJlZV9wYWdlczoKCWZv
ciAoaSA9IDA7IGkgPCBicC0+Yl9wYWdlX2NvdW50OyBpKyspCgkJX19mcmVlX3BhZ2UoYnAtPmJf
cGFnZXNbaV0pOwoJcmV0dXJuIGVycm9yOwp9CgovKgogKglNYXAgYnVmZmVyIGludG8ga2VybmVs
IGFkZHJlc3Mtc3BhY2UgaWYgbmVjZXNzYXJ5LgogKi8KU1RBVElDIGludApfeGZzX2J1Zl9tYXBf
cGFnZXMoCgl4ZnNfYnVmX3QJCSpicCwKCXVpbnQJCQlmbGFncykKewoJQVNTRVJUKGJwLT5iX2Zs
YWdzICYgX1hCRl9QQUdFUyk7CglpZiAoYnAtPmJfcGFnZV9jb3VudCA9PSAxKSB7CgkJLyogQSBz
aW5nbGUgcGFnZSBidWZmZXIgaXMgYWx3YXlzIG1hcHBhYmxlICovCgkJYnAtPmJfYWRkciA9IHBh
Z2VfYWRkcmVzcyhicC0+Yl9wYWdlc1swXSkgKyBicC0+Yl9vZmZzZXQ7Cgl9IGVsc2UgaWYgKGZs
YWdzICYgWEJGX1VOTUFQUEVEKSB7CgkJYnAtPmJfYWRkciA9IE5VTEw7Cgl9IGVsc2UgewoJCWlu
dCByZXRyaWVkID0gMDsKCQl1bnNpZ25lZCBub2lvX2ZsYWc7CgoJCS8qCgkJICogdm1fbWFwX3Jh
bSgpIHdpbGwgYWxsb2NhdGUgYXV4aWxsYXJ5IHN0cnVjdHVyZXMgKGUuZy4KCQkgKiBwYWdldGFi
bGVzKSB3aXRoIEdGUF9LRVJORUwsIHlldCB3ZSBhcmUgbGlrZWx5IHRvIGJlIHVuZGVyCgkJICog
R0ZQX05PRlMgY29udGV4dCBoZXJlLiBIZW5jZSB3ZSBuZWVkIHRvIHRlbGwgbWVtb3J5IHJlY2xh
aW0KCQkgKiB0aGF0IHdlIGFyZSBpbiBzdWNoIGEgY29udGV4dCB2aWEgUEZfTUVNQUxMT0NfTk9J
TyB0byBwcmV2ZW50CgkJICogbWVtb3J5IHJlY2xhaW0gcmUtZW50ZXJpbmcgdGhlIGZpbGVzeXN0
ZW0gaGVyZSBhbmQKCQkgKiBwb3RlbnRpYWxseSBkZWFkbG9ja2luZy4KCQkgKi8KCQlub2lvX2Zs
YWcgPSBtZW1hbGxvY19ub2lvX3NhdmUoKTsKCQlkbyB7CgkJCWJwLT5iX2FkZHIgPSB2bV9tYXBf
cmFtKGJwLT5iX3BhZ2VzLCBicC0+Yl9wYWdlX2NvdW50LAoJCQkJCQktMSwgUEFHRV9LRVJORUwp
OwoJCQlpZiAoYnAtPmJfYWRkcikKCQkJCWJyZWFrOwoJCQl2bV91bm1hcF9hbGlhc2VzKCk7CgkJ
fSB3aGlsZSAocmV0cmllZCsrIDw9IDEpOwoJCW1lbWFsbG9jX25vaW9fcmVzdG9yZShub2lvX2Zs
YWcpOwoKCQlpZiAoIWJwLT5iX2FkZHIpCgkJCXJldHVybiAtRU5PTUVNOwoJCWJwLT5iX2FkZHIg
Kz0gYnAtPmJfb2Zmc2V0OwoJfQoKCXJldHVybiAwOwp9CgovKgogKglGaW5kaW5nIGFuZCBSZWFk
aW5nIEJ1ZmZlcnMKICovCgovKgogKglMb29rIHVwLCBhbmQgY3JlYXRlcyBpZiBhYnNlbnQsIGEg
bG9ja2FibGUgYnVmZmVyIGZvcgogKglhIGdpdmVuIHJhbmdlIG9mIGFuIGlub2RlLiAgVGhlIGJ1
ZmZlciBpcyByZXR1cm5lZAogKglsb2NrZWQuCU5vIEkvTyBpcyBpbXBsaWVkIGJ5IHRoaXMgY2Fs
bC4KICovCnhmc19idWZfdCAqCl94ZnNfYnVmX2ZpbmQoCglzdHJ1Y3QgeGZzX2J1ZnRhcmcJKmJ0
cCwKCXN0cnVjdCB4ZnNfYnVmX21hcAkqbWFwLAoJaW50CQkJbm1hcHMsCgl4ZnNfYnVmX2ZsYWdz
X3QJCWZsYWdzLAoJeGZzX2J1Zl90CQkqbmV3X2JwKQp7CglzaXplX3QJCQludW1ieXRlczsKCXN0
cnVjdCB4ZnNfcGVyYWcJKnBhZzsKCXN0cnVjdCByYl9ub2RlCQkqKnJicDsKCXN0cnVjdCByYl9u
b2RlCQkqcGFyZW50OwoJeGZzX2J1Zl90CQkqYnA7Cgl4ZnNfZGFkZHJfdAkJYmxrbm8gPSBtYXBb
MF0uYm1fYm47Cgl4ZnNfZGFkZHJfdAkJZW9mczsKCWludAkJCW51bWJsa3MgPSAwOwoJaW50CQkJ
aTsKCglmb3IgKGkgPSAwOyBpIDwgbm1hcHM7IGkrKykKCQludW1ibGtzICs9IG1hcFtpXS5ibV9s
ZW47CgludW1ieXRlcyA9IEJCVE9CKG51bWJsa3MpOwoKCS8qIENoZWNrIGZvciBJT3Mgc21hbGxl
ciB0aGFuIHRoZSBzZWN0b3Igc2l6ZSAvIG5vdCBzZWN0b3IgYWxpZ25lZCAqLwoJQVNTRVJUKCEo
bnVtYnl0ZXMgPCBidHAtPmJ0X21ldGFfc2VjdG9yc2l6ZSkpOwoJQVNTRVJUKCEoQkJUT0IoYmxr
bm8pICYgKHhmc19vZmZfdClidHAtPmJ0X21ldGFfc2VjdG9ybWFzaykpOwoKCS8qCgkgKiBDb3Jy
dXB0ZWQgYmxvY2sgbnVtYmVycyBjYW4gZ2V0IHRocm91Z2ggdG8gaGVyZSwgdW5mb3J0dW5hdGVs
eSwgc28gd2UKCSAqIGhhdmUgdG8gY2hlY2sgdGhhdCB0aGUgYnVmZmVyIGZhbGxzIHdpdGhpbiB0
aGUgZmlsZXN5c3RlbSBib3VuZHMuCgkgKi8KCWVvZnMgPSBYRlNfRlNCX1RPX0JCKGJ0cC0+YnRf
bW91bnQsIGJ0cC0+YnRfbW91bnQtPm1fc2Iuc2JfZGJsb2Nrcyk7CglpZiAoYmxrbm8gPj0gZW9m
cykgewoJCS8qCgkJICogWFhYIChkZ2MpOiB3ZSBzaG91bGQgcmVhbGx5IGJlIHJldHVybmluZyBF
RlNDT1JSVVBURUQgaGVyZSwKCQkgKiBidXQgbm9uZSBvZiB0aGUgaGlnaGVyIGxldmVsIGluZnJh
c3RydWN0dXJlIHN1cHBvcnRzCgkJICogcmV0dXJuaW5nIGEgc3BlY2lmaWMgZXJyb3Igb24gYnVm
ZmVyIGxvb2t1cCBmYWlsdXJlcy4KCQkgKi8KCQl4ZnNfYWxlcnQoYnRwLT5idF9tb3VudCwKCQkJ
ICAiJXM6IEJsb2NrIG91dCBvZiByYW5nZTogYmxvY2sgMHglbGx4LCBFT0ZTIDB4JWxseCAiLAoJ
CQkgIF9fZnVuY19fLCBibGtubywgZW9mcyk7CgkJV0FSTl9PTigxKTsKCQlyZXR1cm4gTlVMTDsK
CX0KCgkvKiBnZXQgdHJlZSByb290ICovCglwYWcgPSB4ZnNfcGVyYWdfZ2V0KGJ0cC0+YnRfbW91
bnQsCgkJCQl4ZnNfZGFkZHJfdG9fYWdubyhidHAtPmJ0X21vdW50LCBibGtubykpOwoKCS8qIHdh
bGsgdHJlZSAqLwoJc3Bpbl9sb2NrKCZwYWctPnBhZ19idWZfbG9jayk7CglyYnAgPSAmcGFnLT5w
YWdfYnVmX3RyZWUucmJfbm9kZTsKCXBhcmVudCA9IE5VTEw7CglicCA9IE5VTEw7Cgl3aGlsZSAo
KnJicCkgewoJCXBhcmVudCA9ICpyYnA7CgkJYnAgPSByYl9lbnRyeShwYXJlbnQsIHN0cnVjdCB4
ZnNfYnVmLCBiX3Jibm9kZSk7CgoJCWlmIChibGtubyA8IGJwLT5iX2JuKQoJCQlyYnAgPSAmKCpy
YnApLT5yYl9sZWZ0OwoJCWVsc2UgaWYgKGJsa25vID4gYnAtPmJfYm4pCgkJCXJicCA9ICYoKnJi
cCktPnJiX3JpZ2h0OwoJCWVsc2UgewoJCQkvKgoJCQkgKiBmb3VuZCBhIGJsb2NrIG51bWJlciBt
YXRjaC4gSWYgdGhlIHJhbmdlIGRvZXNuJ3QKCQkJICogbWF0Y2gsIHRoZSBvbmx5IHdheSB0aGlz
IGlzIGFsbG93ZWQgaXMgaWYgdGhlIGJ1ZmZlcgoJCQkgKiBpbiB0aGUgY2FjaGUgaXMgc3RhbGUg
YW5kIHRoZSB0cmFuc2FjdGlvbiB0aGF0IG1hZGUKCQkJICogaXQgc3RhbGUgaGFzIG5vdCB5ZXQg
Y29tbWl0dGVkLiBpLmUuIHdlIGFyZQoJCQkgKiByZWFsbG9jYXRpbmcgYSBidXN5IGV4dGVudC4g
U2tpcCB0aGlzIGJ1ZmZlciBhbmQKCQkJICogY29udGludWUgc2VhcmNoaW5nIHRvIHRoZSByaWdo
dCBmb3IgYW4gZXhhY3QgbWF0Y2guCgkJCSAqLwoJCQlpZiAoYnAtPmJfbGVuZ3RoICE9IG51bWJs
a3MpIHsKCQkJCUFTU0VSVChicC0+Yl9mbGFncyAmIFhCRl9TVEFMRSk7CgkJCQlyYnAgPSAmKCpy
YnApLT5yYl9yaWdodDsKCQkJCWNvbnRpbnVlOwoJCQl9CgkJCWF0b21pY19pbmMoJmJwLT5iX2hv
bGQpOwoJCQlnb3RvIGZvdW5kOwoJCX0KCX0KCgkvKiBObyBtYXRjaCBmb3VuZCAqLwoJaWYgKG5l
d19icCkgewoJCXJiX2xpbmtfbm9kZSgmbmV3X2JwLT5iX3Jibm9kZSwgcGFyZW50LCByYnApOwoJ
CXJiX2luc2VydF9jb2xvcigmbmV3X2JwLT5iX3Jibm9kZSwgJnBhZy0+cGFnX2J1Zl90cmVlKTsK
CQkvKiB0aGUgYnVmZmVyIGtlZXBzIHRoZSBwZXJhZyByZWZlcmVuY2UgdW50aWwgaXQgaXMgZnJl
ZWQgKi8KCQluZXdfYnAtPmJfcGFnID0gcGFnOwoJCXNwaW5fdW5sb2NrKCZwYWctPnBhZ19idWZf
bG9jayk7Cgl9IGVsc2UgewoJCVhGU19TVEFUU19JTkMoeGJfbWlzc19sb2NrZWQpOwoJCXNwaW5f
dW5sb2NrKCZwYWctPnBhZ19idWZfbG9jayk7CgkJeGZzX3BlcmFnX3B1dChwYWcpOwoJfQoJcmV0
dXJuIG5ld19icDsKCmZvdW5kOgoJc3Bpbl91bmxvY2soJnBhZy0+cGFnX2J1Zl9sb2NrKTsKCXhm
c19wZXJhZ19wdXQocGFnKTsKCglpZiAoIXhmc19idWZfdHJ5bG9jayhicCkpIHsKCQlpZiAoZmxh
Z3MgJiBYQkZfVFJZTE9DSykgewoJCQl4ZnNfYnVmX3JlbGUoYnApOwoJCQlYRlNfU1RBVFNfSU5D
KHhiX2J1c3lfbG9ja2VkKTsKCQkJcmV0dXJuIE5VTEw7CgkJfQoJCXhmc19idWZfbG9jayhicCk7
CgkJWEZTX1NUQVRTX0lOQyh4Yl9nZXRfbG9ja2VkX3dhaXRlZCk7Cgl9CgoJLyoKCSAqIGlmIHRo
ZSBidWZmZXIgaXMgc3RhbGUsIGNsZWFyIGFsbCB0aGUgZXh0ZXJuYWwgc3RhdGUgYXNzb2NpYXRl
ZCB3aXRoCgkgKiBpdC4gV2UgbmVlZCB0byBrZWVwIGZsYWdzIHN1Y2ggYXMgaG93IHdlIGFsbG9j
YXRlZCB0aGUgYnVmZmVyIG1lbW9yeQoJICogaW50YWN0IGhlcmUuCgkgKi8KCWlmIChicC0+Yl9m
bGFncyAmIFhCRl9TVEFMRSkgewoJCUFTU0VSVCgoYnAtPmJfZmxhZ3MgJiBfWEJGX0RFTFdSSV9R
KSA9PSAwKTsKCQlBU1NFUlQoYnAtPmJfaW9kb25lID09IE5VTEwpOwoJCWJwLT5iX2ZsYWdzICY9
IF9YQkZfS01FTSB8IF9YQkZfUEFHRVM7CgkJYnAtPmJfb3BzID0gTlVMTDsKCX0KCgl0cmFjZV94
ZnNfYnVmX2ZpbmQoYnAsIGZsYWdzLCBfUkVUX0lQXyk7CglYRlNfU1RBVFNfSU5DKHhiX2dldF9s
b2NrZWQpOwoJcmV0dXJuIGJwOwp9CgovKgogKiBBc3NlbWJsZXMgYSBidWZmZXIgY292ZXJpbmcg
dGhlIHNwZWNpZmllZCByYW5nZS4gVGhlIGNvZGUgaXMgb3B0aW1pc2VkIGZvcgogKiBjYWNoZSBo
aXRzLCBhcyBtZXRhZGF0YSBpbnRlbnNpdmUgd29ya2xvYWRzIHdpbGwgc2VlIDMgb3JkZXJzIG9m
IG1hZ25pdHVkZQogKiBtb3JlIGhpdHMgdGhhbiBtaXNzZXMuCiAqLwpzdHJ1Y3QgeGZzX2J1ZiAq
Cnhmc19idWZfZ2V0X21hcCgKCXN0cnVjdCB4ZnNfYnVmdGFyZwkqdGFyZ2V0LAoJc3RydWN0IHhm
c19idWZfbWFwCSptYXAsCglpbnQJCQlubWFwcywKCXhmc19idWZfZmxhZ3NfdAkJZmxhZ3MpCnsK
CXN0cnVjdCB4ZnNfYnVmCQkqYnA7CglzdHJ1Y3QgeGZzX2J1ZgkJKm5ld19icDsKCWludAkJCWVy
cm9yID0gMDsKCglicCA9IF94ZnNfYnVmX2ZpbmQodGFyZ2V0LCBtYXAsIG5tYXBzLCBmbGFncywg
TlVMTCk7CglpZiAobGlrZWx5KGJwKSkKCQlnb3RvIGZvdW5kOwoKCW5ld19icCA9IF94ZnNfYnVm
X2FsbG9jKHRhcmdldCwgbWFwLCBubWFwcywgZmxhZ3MpOwoJaWYgKHVubGlrZWx5KCFuZXdfYnAp
KQoJCXJldHVybiBOVUxMOwoKCWVycm9yID0geGZzX2J1Zl9hbGxvY2F0ZV9tZW1vcnkobmV3X2Jw
LCBmbGFncyk7CglpZiAoZXJyb3IpIHsKCQl4ZnNfYnVmX2ZyZWUobmV3X2JwKTsKCQlyZXR1cm4g
TlVMTDsKCX0KCglicCA9IF94ZnNfYnVmX2ZpbmQodGFyZ2V0LCBtYXAsIG5tYXBzLCBmbGFncywg
bmV3X2JwKTsKCWlmICghYnApIHsKCQl4ZnNfYnVmX2ZyZWUobmV3X2JwKTsKCQlyZXR1cm4gTlVM
TDsKCX0KCglpZiAoYnAgIT0gbmV3X2JwKQoJCXhmc19idWZfZnJlZShuZXdfYnApOwoKZm91bmQ6
CglpZiAoIWJwLT5iX2FkZHIpIHsKCQllcnJvciA9IF94ZnNfYnVmX21hcF9wYWdlcyhicCwgZmxh
Z3MpOwoJCWlmICh1bmxpa2VseShlcnJvcikpIHsKCQkJeGZzX3dhcm4odGFyZ2V0LT5idF9tb3Vu
dCwKCQkJCSIlczogZmFpbGVkIHRvIG1hcCBwYWdlc24iLCBfX2Z1bmNfXyk7CgkJCXhmc19idWZf
cmVsc2UoYnApOwoJCQlyZXR1cm4gTlVMTDsKCQl9Cgl9CgoJWEZTX1NUQVRTX0lOQyh4Yl9nZXQp
OwoJdHJhY2VfeGZzX2J1Zl9nZXQoYnAsIGZsYWdzLCBfUkVUX0lQXyk7CglyZXR1cm4gYnA7Cn0K
ClNUQVRJQyBpbnQKX3hmc19idWZfcmVhZCgKCXhmc19idWZfdAkJKmJwLAoJeGZzX2J1Zl9mbGFn
c190CQlmbGFncykKewoJQVNTRVJUKCEoZmxhZ3MgJiBYQkZfV1JJVEUpKTsKCUFTU0VSVChicC0+
Yl9tYXBzWzBdLmJtX2JuICE9IFhGU19CVUZfREFERFJfTlVMTCk7CgoJYnAtPmJfZmxhZ3MgJj0g
fihYQkZfV1JJVEUgfCBYQkZfQVNZTkMgfCBYQkZfUkVBRF9BSEVBRCk7CglicC0+Yl9mbGFncyB8
PSBmbGFncyAmIChYQkZfUkVBRCB8IFhCRl9BU1lOQyB8IFhCRl9SRUFEX0FIRUFEKTsKCgl4ZnNf
YnVmX2lvcmVxdWVzdChicCk7CglpZiAoZmxhZ3MgJiBYQkZfQVNZTkMpCgkJcmV0dXJuIDA7Cgly
ZXR1cm4geGZzX2J1Zl9pb3dhaXQoYnApOwp9Cgp4ZnNfYnVmX3QgKgp4ZnNfYnVmX3JlYWRfbWFw
KAoJc3RydWN0IHhmc19idWZ0YXJnCSp0YXJnZXQsCglzdHJ1Y3QgeGZzX2J1Zl9tYXAJKm1hcCwK
CWludAkJCW5tYXBzLAoJeGZzX2J1Zl9mbGFnc190CQlmbGFncywKCWNvbnN0IHN0cnVjdCB4ZnNf
YnVmX29wcyAqb3BzKQp7CglzdHJ1Y3QgeGZzX2J1ZgkJKmJwOwoKCWZsYWdzIHw9IFhCRl9SRUFE
OwoKCWJwID0geGZzX2J1Zl9nZXRfbWFwKHRhcmdldCwgbWFwLCBubWFwcywgZmxhZ3MpOwoJaWYg
KGJwKSB7CgkJdHJhY2VfeGZzX2J1Zl9yZWFkKGJwLCBmbGFncywgX1JFVF9JUF8pOwoKCQlpZiAo
IVhGU19CVUZfSVNET05FKGJwKSkgewoJCQlYRlNfU1RBVFNfSU5DKHhiX2dldF9yZWFkKTsKCQkJ
YnAtPmJfb3BzID0gb3BzOwoJCQlfeGZzX2J1Zl9yZWFkKGJwLCBmbGFncyk7CgkJfSBlbHNlIGlm
IChmbGFncyAmIFhCRl9BU1lOQykgewoJCQkvKgoJCQkgKiBSZWFkIGFoZWFkIGNhbGwgd2hpY2gg
aXMgYWxyZWFkeSBzYXRpc2ZpZWQsCgkJCSAqIGRyb3AgdGhlIGJ1ZmZlcgoJCQkgKi8KCQkJeGZz
X2J1Zl9yZWxzZShicCk7CgkJCXJldHVybiBOVUxMOwoJCX0gZWxzZSB7CgkJCS8qIFdlIGRvIG5v
dCB3YW50IHJlYWQgaW4gdGhlIGZsYWdzICovCgkJCWJwLT5iX2ZsYWdzICY9IH5YQkZfUkVBRDsK
CQl9Cgl9CgoJcmV0dXJuIGJwOwp9CgovKgogKglJZiB3ZSBhcmUgbm90IGxvdyBvbiBtZW1vcnkg
dGhlbiBkbyB0aGUgcmVhZGFoZWFkIGluIGEgZGVhZGxvY2sKICoJc2FmZSBtYW5uZXIuCiAqLwp2
b2lkCnhmc19idWZfcmVhZGFoZWFkX21hcCgKCXN0cnVjdCB4ZnNfYnVmdGFyZwkqdGFyZ2V0LAoJ
c3RydWN0IHhmc19idWZfbWFwCSptYXAsCglpbnQJCQlubWFwcywKCWNvbnN0IHN0cnVjdCB4ZnNf
YnVmX29wcyAqb3BzKQp7CglpZiAoYmRpX3JlYWRfY29uZ2VzdGVkKHRhcmdldC0+YnRfYmRpKSkK
CQlyZXR1cm47CgoJeGZzX2J1Zl9yZWFkX21hcCh0YXJnZXQsIG1hcCwgbm1hcHMsCgkJICAgICBY
QkZfVFJZTE9DS3xYQkZfQVNZTkN8WEJGX1JFQURfQUhFQUQsIG9wcyk7Cn0KCi8qCiAqIFJlYWQg
YW4gdW5jYWNoZWQgYnVmZmVyIGZyb20gZGlzay4gQWxsb2NhdGVzIGFuZCByZXR1cm5zIGEgbG9j
a2VkCiAqIGJ1ZmZlciBjb250YWluaW5nIHRoZSBkaXNrIGNvbnRlbnRzIG9yIG5vdGhpbmcuCiAq
LwpzdHJ1Y3QgeGZzX2J1ZiAqCnhmc19idWZfcmVhZF91bmNhY2hlZCgKCXN0cnVjdCB4ZnNfYnVm
dGFyZwkqdGFyZ2V0LAoJeGZzX2RhZGRyX3QJCWRhZGRyLAoJc2l6ZV90CQkJbnVtYmxrcywKCWlu
dAkJCWZsYWdzLAoJY29uc3Qgc3RydWN0IHhmc19idWZfb3BzICpvcHMpCnsKCXN0cnVjdCB4ZnNf
YnVmCQkqYnA7CgoJYnAgPSB4ZnNfYnVmX2dldF91bmNhY2hlZCh0YXJnZXQsIG51bWJsa3MsIGZs
YWdzKTsKCWlmICghYnApCgkJcmV0dXJuIE5VTEw7CgoJLyogc2V0IHVwIHRoZSBidWZmZXIgZm9y
IGEgcmVhZCBJTyAqLwoJQVNTRVJUKGJwLT5iX21hcF9jb3VudCA9PSAxKTsKCWJwLT5iX2JuID0g
ZGFkZHI7CglicC0+Yl9tYXBzWzBdLmJtX2JuID0gZGFkZHI7CglicC0+Yl9mbGFncyB8PSBYQkZf
UkVBRDsKCWJwLT5iX29wcyA9IG9wczsKCglpZiAoWEZTX0ZPUkNFRF9TSFVURE9XTih0YXJnZXQt
PmJ0X21vdW50KSkgewoJCXhmc19idWZfcmVsc2UoYnApOwoJCXJldHVybiBOVUxMOwoJfQoJeGZz
X2J1Zl9pb3JlcXVlc3QoYnApOwoJeGZzX2J1Zl9pb3dhaXQoYnApOwoJcmV0dXJuIGJwOwp9Cgov
KgogKiBSZXR1cm4gYSBidWZmZXIgYWxsb2NhdGVkIGFzIGFuIGVtcHR5IGJ1ZmZlciBhbmQgYXNz
b2NpYXRlZCB0byBleHRlcm5hbAogKiBtZW1vcnkgdmlhIHhmc19idWZfYXNzb2NpYXRlX21lbW9y
eSgpIGJhY2sgdG8gaXQncyBlbXB0eSBzdGF0ZS4KICovCnZvaWQKeGZzX2J1Zl9zZXRfZW1wdHko
CglzdHJ1Y3QgeGZzX2J1ZgkJKmJwLAoJc2l6ZV90CQkJbnVtYmxrcykKewoJaWYgKGJwLT5iX3Bh
Z2VzKQoJCV94ZnNfYnVmX2ZyZWVfcGFnZXMoYnApOwoKCWJwLT5iX3BhZ2VzID0gTlVMTDsKCWJw
LT5iX3BhZ2VfY291bnQgPSAwOwoJYnAtPmJfYWRkciA9IE5VTEw7CglicC0+Yl9sZW5ndGggPSBu
dW1ibGtzOwoJYnAtPmJfaW9fbGVuZ3RoID0gbnVtYmxrczsKCglBU1NFUlQoYnAtPmJfbWFwX2Nv
dW50ID09IDEpOwoJYnAtPmJfYm4gPSBYRlNfQlVGX0RBRERSX05VTEw7CglicC0+Yl9tYXBzWzBd
LmJtX2JuID0gWEZTX0JVRl9EQUREUl9OVUxMOwoJYnAtPmJfbWFwc1swXS5ibV9sZW4gPSBicC0+
Yl9sZW5ndGg7Cn0KCnN0YXRpYyBpbmxpbmUgc3RydWN0IHBhZ2UgKgptZW1fdG9fcGFnZSgKCXZv
aWQJCQkqYWRkcikKewoJaWYgKCghaXNfdm1hbGxvY19hZGRyKGFkZHIpKSkgewoJCXJldHVybiB2
aXJ0X3RvX3BhZ2UoYWRkcik7Cgl9IGVsc2UgewoJCXJldHVybiB2bWFsbG9jX3RvX3BhZ2UoYWRk
cik7Cgl9Cn0KCmludAp4ZnNfYnVmX2Fzc29jaWF0ZV9tZW1vcnkoCgl4ZnNfYnVmX3QJCSpicCwK
CXZvaWQJCQkqbWVtLAoJc2l6ZV90CQkJbGVuKQp7CglpbnQJCQlydmFsOwoJaW50CQkJaSA9IDA7
Cgl1bnNpZ25lZCBsb25nCQlwYWdlYWRkcjsKCXVuc2lnbmVkIGxvbmcJCW9mZnNldDsKCXNpemVf
dAkJCWJ1ZmxlbjsKCWludAkJCXBhZ2VfY291bnQ7CgoJcGFnZWFkZHIgPSAodW5zaWduZWQgbG9u
ZyltZW0gJiBQQUdFX01BU0s7CglvZmZzZXQgPSAodW5zaWduZWQgbG9uZyltZW0gLSBwYWdlYWRk
cjsKCWJ1ZmxlbiA9IFBBR0VfQUxJR04obGVuICsgb2Zmc2V0KTsKCXBhZ2VfY291bnQgPSBidWZs
ZW4gPj4gUEFHRV9TSElGVDsKCgkvKiBGcmVlIGFueSBwcmV2aW91cyBzZXQgb2YgcGFnZSBwb2lu
dGVycyAqLwoJaWYgKGJwLT5iX3BhZ2VzKQoJCV94ZnNfYnVmX2ZyZWVfcGFnZXMoYnApOwoKCWJw
LT5iX3BhZ2VzID0gTlVMTDsKCWJwLT5iX2FkZHIgPSBtZW07CgoJcnZhbCA9IF94ZnNfYnVmX2dl
dF9wYWdlcyhicCwgcGFnZV9jb3VudCk7CglpZiAocnZhbCkKCQlyZXR1cm4gcnZhbDsKCglicC0+
Yl9vZmZzZXQgPSBvZmZzZXQ7CgoJZm9yIChpID0gMDsgaSA8IGJwLT5iX3BhZ2VfY291bnQ7IGkr
KykgewoJCWJwLT5iX3BhZ2VzW2ldID0gbWVtX3RvX3BhZ2UoKHZvaWQgKilwYWdlYWRkcik7CgkJ
cGFnZWFkZHIgKz0gUEFHRV9TSVpFOwoJfQoKCWJwLT5iX2lvX2xlbmd0aCA9IEJUT0JCKGxlbik7
CglicC0+Yl9sZW5ndGggPSBCVE9CQihidWZsZW4pOwoKCXJldHVybiAwOwp9Cgp4ZnNfYnVmX3Qg
Kgp4ZnNfYnVmX2dldF91bmNhY2hlZCgKCXN0cnVjdCB4ZnNfYnVmdGFyZwkqdGFyZ2V0LAoJc2l6
ZV90CQkJbnVtYmxrcywKCWludAkJCWZsYWdzKQp7Cgl1bnNpZ25lZCBsb25nCQlwYWdlX2NvdW50
OwoJaW50CQkJZXJyb3IsIGk7CglzdHJ1Y3QgeGZzX2J1ZgkJKmJwOwoJREVGSU5FX1NJTkdMRV9C
VUZfTUFQKG1hcCwgWEZTX0JVRl9EQUREUl9OVUxMLCBudW1ibGtzKTsKCglicCA9IF94ZnNfYnVm
X2FsbG9jKHRhcmdldCwgJm1hcCwgMSwgMCk7CglpZiAodW5saWtlbHkoYnAgPT0gTlVMTCkpCgkJ
Z290byBmYWlsOwoKCXBhZ2VfY291bnQgPSBQQUdFX0FMSUdOKG51bWJsa3MgPDwgQkJTSElGVCkg
Pj4gUEFHRV9TSElGVDsKCWVycm9yID0gX3hmc19idWZfZ2V0X3BhZ2VzKGJwLCBwYWdlX2NvdW50
KTsKCWlmIChlcnJvcikKCQlnb3RvIGZhaWxfZnJlZV9idWY7CgoJZm9yIChpID0gMDsgaSA8IHBh
Z2VfY291bnQ7IGkrKykgewoJCWJwLT5iX3BhZ2VzW2ldID0gYWxsb2NfcGFnZSh4Yl90b19nZnAo
ZmxhZ3MpKTsKCQlpZiAoIWJwLT5iX3BhZ2VzW2ldKQoJCQlnb3RvIGZhaWxfZnJlZV9tZW07Cgl9
CglicC0+Yl9mbGFncyB8PSBfWEJGX1BBR0VTOwoKCWVycm9yID0gX3hmc19idWZfbWFwX3BhZ2Vz
KGJwLCAwKTsKCWlmICh1bmxpa2VseShlcnJvcikpIHsKCQl4ZnNfd2Fybih0YXJnZXQtPmJ0X21v
dW50LAoJCQkiJXM6IGZhaWxlZCB0byBtYXAgcGFnZXMiLCBfX2Z1bmNfXyk7CgkJZ290byBmYWls
X2ZyZWVfbWVtOwoJfQoKCXRyYWNlX3hmc19idWZfZ2V0X3VuY2FjaGVkKGJwLCBfUkVUX0lQXyk7
CglyZXR1cm4gYnA7CgogZmFpbF9mcmVlX21lbToKCXdoaWxlICgtLWkgPj0gMCkKCQlfX2ZyZWVf
cGFnZShicC0+Yl9wYWdlc1tpXSk7CglfeGZzX2J1Zl9mcmVlX3BhZ2VzKGJwKTsKIGZhaWxfZnJl
ZV9idWY6Cgl4ZnNfYnVmX2ZyZWVfbWFwcyhicCk7CglrbWVtX3pvbmVfZnJlZSh4ZnNfYnVmX3pv
bmUsIGJwKTsKIGZhaWw6CglyZXR1cm4gTlVMTDsKfQoKLyoKICoJSW5jcmVtZW50IHJlZmVyZW5j
ZSBjb3VudCBvbiBidWZmZXIsIHRvIGhvbGQgdGhlIGJ1ZmZlciBjb25jdXJyZW50bHkKICoJd2l0
aCBhbm90aGVyIHRocmVhZCB3aGljaCBtYXkgcmVsZWFzZSAoZnJlZSkgdGhlIGJ1ZmZlciBhc3lu
Y2hyb25vdXNseS4KICoJTXVzdCBob2xkIHRoZSBidWZmZXIgYWxyZWFkeSB0byBjYWxsIHRoaXMg
ZnVuY3Rpb24uCiAqLwp2b2lkCnhmc19idWZfaG9sZCgKCXhmc19idWZfdAkJKmJwKQp7Cgl0cmFj
ZV94ZnNfYnVmX2hvbGQoYnAsIF9SRVRfSVBfKTsKCWF0b21pY19pbmMoJmJwLT5iX2hvbGQpOwp9
CgovKgogKglSZWxlYXNlcyBhIGhvbGQgb24gdGhlIHNwZWNpZmllZCBidWZmZXIuICBJZiB0aGUK
ICoJdGhlIGhvbGQgY291bnQgaXMgMSwgY2FsbHMgeGZzX2J1Zl9mcmVlLgogKi8Kdm9pZAp4ZnNf
YnVmX3JlbGUoCgl4ZnNfYnVmX3QJCSpicCkKewoJc3RydWN0IHhmc19wZXJhZwkqcGFnID0gYnAt
PmJfcGFnOwoKCXRyYWNlX3hmc19idWZfcmVsZShicCwgX1JFVF9JUF8pOwoKCWlmICghcGFnKSB7
CgkJQVNTRVJUKGxpc3RfZW1wdHkoJmJwLT5iX2xydSkpOwoJCUFTU0VSVChSQl9FTVBUWV9OT0RF
KCZicC0+Yl9yYm5vZGUpKTsKCQlpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmYnAtPmJfaG9sZCkp
CgkJCXhmc19idWZfZnJlZShicCk7CgkJcmV0dXJuOwoJfQoKCUFTU0VSVCghUkJfRU1QVFlfTk9E
RSgmYnAtPmJfcmJub2RlKSk7CgoJQVNTRVJUKGF0b21pY19yZWFkKCZicC0+Yl9ob2xkKSA+IDAp
OwoJaWYgKGF0b21pY19kZWNfYW5kX2xvY2soJmJwLT5iX2hvbGQsICZwYWctPnBhZ19idWZfbG9j
aykpIHsKCQlzcGluX2xvY2soJmJwLT5iX2xvY2spOwoJCWlmICghKGJwLT5iX2ZsYWdzICYgWEJG
X1NUQUxFKSAmJiBhdG9taWNfcmVhZCgmYnAtPmJfbHJ1X3JlZikpIHsKCQkJLyoKCQkJICogSWYg
dGhlIGJ1ZmZlciBpcyBhZGRlZCB0byB0aGUgTFJVIHRha2UgYSBuZXcKCQkJICogcmVmZXJlbmNl
IHRvIHRoZSBidWZmZXIgZm9yIHRoZSBMUlUgYW5kIGNsZWFyIHRoZQoJCQkgKiAobm93IHN0YWxl
KSBkaXNwb3NlIGxpc3Qgc3RhdGUgZmxhZwoJCQkgKi8KCQkJaWYgKGxpc3RfbHJ1X2FkZCgmYnAt
PmJfdGFyZ2V0LT5idF9scnUsICZicC0+Yl9scnUpKSB7CgkJCQlicC0+Yl9zdGF0ZSAmPSB+WEZT
X0JTVEFURV9ESVNQT1NFOwoJCQkJYXRvbWljX2luYygmYnAtPmJfaG9sZCk7CgkJCX0KCQkJc3Bp
bl91bmxvY2soJmJwLT5iX2xvY2spOwoJCQlzcGluX3VubG9jaygmcGFnLT5wYWdfYnVmX2xvY2sp
OwoJCX0gZWxzZSB7CgkJCS8qCgkJCSAqIG1vc3Qgb2YgdGhlIHRpbWUgYnVmZmVycyB3aWxsIGFs
cmVhZHkgYmUgcmVtb3ZlZCBmcm9tCgkJCSAqIHRoZSBMUlUsIHNvIG9wdGltaXNlIHRoYXQgY2Fz
ZSBieSBjaGVja2luZyBmb3IgdGhlCgkJCSAqIFhGU19CU1RBVEVfRElTUE9TRSBmbGFnIGluZGlj
YXRpbmcgdGhlIGxhc3QgbGlzdCB0aGUKCQkJICogYnVmZmVyIHdhcyBvbiB3YXMgdGhlIGRpc3Bv
c2FsIGxpc3QKCQkJICovCgkJCWlmICghKGJwLT5iX3N0YXRlICYgWEZTX0JTVEFURV9ESVNQT1NF
KSkgewoJCQkJbGlzdF9scnVfZGVsKCZicC0+Yl90YXJnZXQtPmJ0X2xydSwgJmJwLT5iX2xydSk7
CgkJCX0gZWxzZSB7CgkJCQlBU1NFUlQobGlzdF9lbXB0eSgmYnAtPmJfbHJ1KSk7CgkJCX0KCQkJ
c3Bpbl91bmxvY2soJmJwLT5iX2xvY2spOwoKCQkJQVNTRVJUKCEoYnAtPmJfZmxhZ3MgJiBfWEJG
X0RFTFdSSV9RKSk7CgkJCXJiX2VyYXNlKCZicC0+Yl9yYm5vZGUsICZwYWctPnBhZ19idWZfdHJl
ZSk7CgkJCXNwaW5fdW5sb2NrKCZwYWctPnBhZ19idWZfbG9jayk7CgkJCXhmc19wZXJhZ19wdXQo
cGFnKTsKCQkJeGZzX2J1Zl9mcmVlKGJwKTsKCQl9Cgl9Cn0KCgovKgogKglMb2NrIGEgYnVmZmVy
IG9iamVjdCwgaWYgaXQgaXMgbm90IGFscmVhZHkgbG9ja2VkLgogKgogKglJZiB3ZSBjb21lIGFj
cm9zcyBhIHN0YWxlLCBwaW5uZWQsIGxvY2tlZCBidWZmZXIsIHdlIGtub3cgdGhhdCB3ZSBhcmUK
ICoJYmVpbmcgYXNrZWQgdG8gbG9jayBhIGJ1ZmZlciB0aGF0IGhhcyBiZWVuIHJlYWxsb2NhdGVk
LiBCZWNhdXNlIGl0IGlzCiAqCXBpbm5lZCwgd2Uga25vdyB0aGF0IHRoZSBsb2cgaGFzIG5vdCBi
ZWVuIHB1c2hlZCB0byBkaXNrIGFuZCBoZW5jZSBpdAogKgl3aWxsIHN0aWxsIGJlIGxvY2tlZC4g
IFJhdGhlciB0aGFuIGNvbnRpbnVpbmcgdG8gaGF2ZSB0cnlsb2NrIGF0dGVtcHRzCiAqCWZhaWwg
dW50aWwgc29tZW9uZSBlbHNlIHB1c2hlcyB0aGUgbG9nLCBwdXNoIGl0IG91cnNlbHZlcyBiZWZv
cmUKICoJcmV0dXJuaW5nLiAgVGhpcyBtZWFucyB0aGF0IHRoZSB4ZnNhaWxkIHdpbGwgbm90IGdl
dCBzdHVjayB0cnlpbmcKICoJdG8gcHVzaCBvbiBzdGFsZSBpbm9kZSBidWZmZXJzLgogKi8KaW50
Cnhmc19idWZfdHJ5bG9jaygKCXN0cnVjdCB4ZnNfYnVmCQkqYnApCnsKCWludAkJCWxvY2tlZDsK
Cglsb2NrZWQgPSBkb3duX3RyeWxvY2soJmJwLT5iX3NlbWEpID09IDA7CglpZiAobG9ja2VkKQoJ
CVhCX1NFVF9PV05FUihicCk7CgoJdHJhY2VfeGZzX2J1Zl90cnlsb2NrKGJwLCBfUkVUX0lQXyk7
CglyZXR1cm4gbG9ja2VkOwp9CgovKgogKglMb2NrIGEgYnVmZmVyIG9iamVjdC4KICoKICoJSWYg
d2UgY29tZSBhY3Jvc3MgYSBzdGFsZSwgcGlubmVkLCBsb2NrZWQgYnVmZmVyLCB3ZSBrbm93IHRo
YXQgd2UKICoJYXJlIGJlaW5nIGFza2VkIHRvIGxvY2sgYSBidWZmZXIgdGhhdCBoYXMgYmVlbiBy
ZWFsbG9jYXRlZC4gQmVjYXVzZQogKglpdCBpcyBwaW5uZWQsIHdlIGtub3cgdGhhdCB0aGUgbG9n
IGhhcyBub3QgYmVlbiBwdXNoZWQgdG8gZGlzayBhbmQKICoJaGVuY2UgaXQgd2lsbCBzdGlsbCBi
ZSBsb2NrZWQuIFJhdGhlciB0aGFuIHNsZWVwaW5nIHVudGlsIHNvbWVvbmUKICoJZWxzZSBwdXNo
ZXMgdGhlIGxvZywgcHVzaCBpdCBvdXJzZWx2ZXMgYmVmb3JlIHRyeWluZyB0byBnZXQgdGhlIGxv
Y2suCiAqLwp2b2lkCnhmc19idWZfbG9jaygKCXN0cnVjdCB4ZnNfYnVmCQkqYnApCnsKCXRyYWNl
X3hmc19idWZfbG9jayhicCwgX1JFVF9JUF8pOwoKCWlmIChhdG9taWNfcmVhZCgmYnAtPmJfcGlu
X2NvdW50KSAmJiAoYnAtPmJfZmxhZ3MgJiBYQkZfU1RBTEUpKQoJCXhmc19sb2dfZm9yY2UoYnAt
PmJfdGFyZ2V0LT5idF9tb3VudCwgMCk7Cglkb3duKCZicC0+Yl9zZW1hKTsKCVhCX1NFVF9PV05F
UihicCk7CgoJdHJhY2VfeGZzX2J1Zl9sb2NrX2RvbmUoYnAsIF9SRVRfSVBfKTsKfQoKdm9pZAp4
ZnNfYnVmX3VubG9jaygKCXN0cnVjdCB4ZnNfYnVmCQkqYnApCnsKCVhCX0NMRUFSX09XTkVSKGJw
KTsKCXVwKCZicC0+Yl9zZW1hKTsKCgl0cmFjZV94ZnNfYnVmX3VubG9jayhicCwgX1JFVF9JUF8p
Owp9CgpTVEFUSUMgdm9pZAp4ZnNfYnVmX3dhaXRfdW5waW4oCgl4ZnNfYnVmX3QJCSpicCkKewoJ
REVDTEFSRV9XQUlUUVVFVUUJKHdhaXQsIGN1cnJlbnQpOwoKCWlmIChhdG9taWNfcmVhZCgmYnAt
PmJfcGluX2NvdW50KSA9PSAwKQoJCXJldHVybjsKCglhZGRfd2FpdF9xdWV1ZSgmYnAtPmJfd2Fp
dGVycywgJndhaXQpOwoJZm9yICg7OykgewoJCXNldF9jdXJyZW50X3N0YXRlKFRBU0tfVU5JTlRF
UlJVUFRJQkxFKTsKCQlpZiAoYXRvbWljX3JlYWQoJmJwLT5iX3Bpbl9jb3VudCkgPT0gMCkKCQkJ
YnJlYWs7CgkJaW9fc2NoZWR1bGUoKTsKCX0KCXJlbW92ZV93YWl0X3F1ZXVlKCZicC0+Yl93YWl0
ZXJzLCAmd2FpdCk7CglzZXRfY3VycmVudF9zdGF0ZShUQVNLX1JVTk5JTkcpOwp9CgovKgogKglC
dWZmZXIgVXRpbGl0eSBSb3V0aW5lcwogKi8KClNUQVRJQyB2b2lkCnhmc19idWZfaW9kb25lX3dv
cmsoCglzdHJ1Y3Qgd29ya19zdHJ1Y3QJKndvcmspCnsKCXN0cnVjdCB4ZnNfYnVmCQkqYnAgPQoJ
CWNvbnRhaW5lcl9vZih3b3JrLCB4ZnNfYnVmX3QsIGJfaW9kb25lX3dvcmspOwoJYm9vbAkJCXJl
YWQgPSAhIShicC0+Yl9mbGFncyAmIFhCRl9SRUFEKTsKCglicC0+Yl9mbGFncyAmPSB+KFhCRl9S
RUFEIHwgWEJGX1dSSVRFIHwgWEJGX1JFQURfQUhFQUQpOwoKCS8qIG9ubHkgdmFsaWRhdGUgYnVm
ZmVycyB0aGF0IHdlcmUgcmVhZCB3aXRob3V0IGVycm9ycyAqLwoJaWYgKHJlYWQgJiYgYnAtPmJf
b3BzICYmICFicC0+Yl9lcnJvciAmJiAoYnAtPmJfZmxhZ3MgJiBYQkZfRE9ORSkpCgkJYnAtPmJf
b3BzLT52ZXJpZnlfcmVhZChicCk7CgoJaWYgKGJwLT5iX2lvZG9uZSkKCQkoKihicC0+Yl9pb2Rv
bmUpKShicCk7CgllbHNlIGlmIChicC0+Yl9mbGFncyAmIFhCRl9BU1lOQykKCQl4ZnNfYnVmX3Jl
bHNlKGJwKTsKCWVsc2UgewoJCUFTU0VSVChyZWFkICYmIGJwLT5iX29wcyk7CgkJY29tcGxldGUo
JmJwLT5iX2lvd2FpdCk7Cgl9Cn0KCnZvaWQKeGZzX2J1Zl9pb2VuZCgKCXN0cnVjdCB4ZnNfYnVm
CSpicCwKCWludAkJc2NoZWR1bGUpCnsKCWJvb2wJCXJlYWQgPSAhIShicC0+Yl9mbGFncyAmIFhC
Rl9SRUFEKTsKCgl0cmFjZV94ZnNfYnVmX2lvZG9uZShicCwgX1JFVF9JUF8pOwoKCWlmIChicC0+
Yl9lcnJvciA9PSAwKQoJCWJwLT5iX2ZsYWdzIHw9IFhCRl9ET05FOwoKCWlmIChicC0+Yl9pb2Rv
bmUgfHwgKHJlYWQgJiYgYnAtPmJfb3BzKSB8fCAoYnAtPmJfZmxhZ3MgJiBYQkZfQVNZTkMpKSB7
CgkJaWYgKHNjaGVkdWxlKSB7CgkJCUlOSVRfV09SSygmYnAtPmJfaW9kb25lX3dvcmssIHhmc19i
dWZfaW9kb25lX3dvcmspOwoJCQlxdWV1ZV93b3JrKHhmc2xvZ2Rfd29ya3F1ZXVlLCAmYnAtPmJf
aW9kb25lX3dvcmspOwoJCX0gZWxzZSB7CgkJCXhmc19idWZfaW9kb25lX3dvcmsoJmJwLT5iX2lv
ZG9uZV93b3JrKTsKCQl9Cgl9IGVsc2UgewoJCWJwLT5iX2ZsYWdzICY9IH4oWEJGX1JFQUQgfCBY
QkZfV1JJVEUgfCBYQkZfUkVBRF9BSEVBRCk7CgkJY29tcGxldGUoJmJwLT5iX2lvd2FpdCk7Cgl9
Cn0KCnZvaWQKeGZzX2J1Zl9pb2Vycm9yKAoJeGZzX2J1Zl90CQkqYnAsCglpbnQJCQllcnJvcikK
ewoJQVNTRVJUKGVycm9yID49IDAgJiYgZXJyb3IgPD0gMHhmZmZmKTsKCWJwLT5iX2Vycm9yID0g
KHVuc2lnbmVkIHNob3J0KWVycm9yOwoJdHJhY2VfeGZzX2J1Zl9pb2Vycm9yKGJwLCBlcnJvciwg
X1JFVF9JUF8pOwp9Cgp2b2lkCnhmc19idWZfaW9lcnJvcl9hbGVydCgKCXN0cnVjdCB4ZnNfYnVm
CQkqYnAsCgljb25zdCBjaGFyCQkqZnVuYykKewoJeGZzX2FsZXJ0KGJwLT5iX3RhcmdldC0+YnRf
bW91bnQsCiJtZXRhZGF0YSBJL08gZXJyb3I6IGJsb2NrIDB4JWxseCAoXCIlc1wiKSBlcnJvciAl
ZCBudW1ibGtzICVkIiwKCQkoX191aW50NjRfdClYRlNfQlVGX0FERFIoYnApLCBmdW5jLCBicC0+
Yl9lcnJvciwgYnAtPmJfbGVuZ3RoKTsKfQoKLyoKICogQ2FsbGVkIHdoZW4gd2Ugd2FudCB0byBz
dG9wIGEgYnVmZmVyIGZyb20gZ2V0dGluZyB3cml0dGVuIG9yIHJlYWQuCiAqIFdlIGF0dGFjaCB0
aGUgRUlPIGVycm9yLCBtdWNrIHdpdGggaXRzIGZsYWdzLCBhbmQgY2FsbCB4ZnNfYnVmX2lvZW5k
CiAqIHNvIHRoYXQgdGhlIHByb3BlciBpb2RvbmUgY2FsbGJhY2tzIGdldCBjYWxsZWQuCiAqLwpT
VEFUSUMgaW50Cnhmc19iaW9lcnJvcigKCXhmc19idWZfdCAqYnApCnsKI2lmZGVmIFhGU0VSUk9S
REVCVUcKCUFTU0VSVChYRlNfQlVGX0lTUkVBRChicCkgfHwgYnAtPmJfaW9kb25lKTsKI2VuZGlm
CgoJLyoKCSAqIE5vIG5lZWQgdG8gd2FpdCB1bnRpbCB0aGUgYnVmZmVyIGlzIHVucGlubmVkLCB3
ZSBhcmVuJ3QgZmx1c2hpbmcgaXQuCgkgKi8KCXhmc19idWZfaW9lcnJvcihicCwgRUlPKTsKCgkv
KgoJICogV2UncmUgY2FsbGluZyB4ZnNfYnVmX2lvZW5kLCBzbyBkZWxldGUgWEJGX0RPTkUgZmxh
Zy4KCSAqLwoJWEZTX0JVRl9VTlJFQUQoYnApOwoJWEZTX0JVRl9VTkRPTkUoYnApOwoJeGZzX2J1
Zl9zdGFsZShicCk7CgoJeGZzX2J1Zl9pb2VuZChicCwgMCk7CgoJcmV0dXJuIEVJTzsKfQoKLyoK
ICogU2FtZSBhcyB4ZnNfYmlvZXJyb3IsIGV4Y2VwdCB0aGF0IHdlIGFyZSByZWxlYXNpbmcgdGhl
IGJ1ZmZlcgogKiBoZXJlIG91cnNlbHZlcywgYW5kIGF2b2lkaW5nIHRoZSB4ZnNfYnVmX2lvZW5k
IGNhbGwuCiAqIFRoaXMgaXMgbWVhbnQgZm9yIHVzZXJkYXRhIGVycm9yczsgbWV0YWRhdGEgYnVm
cyBjb21lIHdpdGgKICogaW9kb25lIGZ1bmN0aW9ucyBhdHRhY2hlZCwgc28gdGhhdCB3ZSBjYW4g
dHJhY2sgZG93biBlcnJvcnMuCiAqLwppbnQKeGZzX2Jpb2Vycm9yX3JlbHNlKAoJc3RydWN0IHhm
c19idWYJKmJwKQp7CglpbnQ2NF90CQlmbCA9IGJwLT5iX2ZsYWdzOwoJLyoKCSAqIE5vIG5lZWQg
dG8gd2FpdCB1bnRpbCB0aGUgYnVmZmVyIGlzIHVucGlubmVkLgoJICogV2UgYXJlbid0IGZsdXNo
aW5nIGl0LgoJICoKCSAqIGNodW5raG9sZCBleHBlY3RzIEJfRE9ORSB0byBiZSBzZXQsIHdoZXRo
ZXIKCSAqIHdlIGFjdHVhbGx5IGZpbmlzaCB0aGUgSS9PIG9yIG5vdC4gV2UgZG9uJ3Qgd2FudCB0
bwoJICogY2hhbmdlIHRoYXQgaW50ZXJmYWNlLgoJICovCglYRlNfQlVGX1VOUkVBRChicCk7CglY
RlNfQlVGX0RPTkUoYnApOwoJeGZzX2J1Zl9zdGFsZShicCk7CglicC0+Yl9pb2RvbmUgPSBOVUxM
OwoJaWYgKCEoZmwgJiBYQkZfQVNZTkMpKSB7CgkJLyoKCQkgKiBNYXJrIGJfZXJyb3IgYW5kIEJf
RVJST1IgX2JvdGhfLgoJCSAqIExvdCdzIG9mIGNodW5rY2FjaGUgY29kZSBhc3N1bWVzIHRoYXQu
CgkJICogVGhlcmUncyBubyByZWFzb24gdG8gbWFyayBlcnJvciBmb3IKCQkgKiBBU1lOQyBidWZm
ZXJzLgoJCSAqLwoJCXhmc19idWZfaW9lcnJvcihicCwgRUlPKTsKCQljb21wbGV0ZSgmYnAtPmJf
aW93YWl0KTsKCX0gZWxzZSB7CgkJeGZzX2J1Zl9yZWxzZShicCk7Cgl9CgoJcmV0dXJuIEVJTzsK
fQoKU1RBVElDIGludAp4ZnNfYmRzdHJhdF9jYigKCXN0cnVjdCB4ZnNfYnVmCSpicCkKewoJaWYg
KFhGU19GT1JDRURfU0hVVERPV04oYnAtPmJfdGFyZ2V0LT5idF9tb3VudCkpIHsKCQl0cmFjZV94
ZnNfYmRzdHJhdF9zaHV0KGJwLCBfUkVUX0lQXyk7CgkJLyoKCQkgKiBNZXRhZGF0YSB3cml0ZSB0
aGF0IGRpZG4ndCBnZXQgbG9nZ2VkIGJ1dAoJCSAqIHdyaXR0ZW4gZGVsYXllZCBhbnl3YXkuIFRo
ZXNlIGFyZW4ndCBhc3NvY2lhdGVkCgkJICogd2l0aCBhIHRyYW5zYWN0aW9uLCBhbmQgY2FuIGJl
IGlnbm9yZWQuCgkJICovCgkJaWYgKCFicC0+Yl9pb2RvbmUgJiYgIVhGU19CVUZfSVNSRUFEKGJw
KSkKCQkJcmV0dXJuIHhmc19iaW9lcnJvcl9yZWxzZShicCk7CgkJZWxzZQoJCQlyZXR1cm4geGZz
X2Jpb2Vycm9yKGJwKTsKCX0KCgl4ZnNfYnVmX2lvcmVxdWVzdChicCk7CglyZXR1cm4gMDsKfQoK
aW50Cnhmc19id3JpdGUoCglzdHJ1Y3QgeGZzX2J1ZgkJKmJwKQp7CglpbnQJCQllcnJvcjsKCglB
U1NFUlQoeGZzX2J1Zl9pc2xvY2tlZChicCkpOwoKCWJwLT5iX2ZsYWdzIHw9IFhCRl9XUklURTsK
CWJwLT5iX2ZsYWdzICY9IH4oWEJGX0FTWU5DIHwgWEJGX1JFQUQgfCBfWEJGX0RFTFdSSV9RIHwg
WEJGX1dSSVRFX0ZBSUwpOwoKCXhmc19iZHN0cmF0X2NiKGJwKTsKCgllcnJvciA9IHhmc19idWZf
aW93YWl0KGJwKTsKCWlmIChlcnJvcikgewoJCXhmc19mb3JjZV9zaHV0ZG93bihicC0+Yl90YXJn
ZXQtPmJ0X21vdW50LAoJCQkJICAgU0hVVERPV05fTUVUQV9JT19FUlJPUik7Cgl9CglyZXR1cm4g
ZXJyb3I7Cn0KClNUQVRJQyB2b2lkCl94ZnNfYnVmX2lvZW5kKAoJeGZzX2J1Zl90CQkqYnAsCglp
bnQJCQlzY2hlZHVsZSkKewoJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3QoJmJwLT5iX2lvX3JlbWFp
bmluZykgPT0gMSkKCQl4ZnNfYnVmX2lvZW5kKGJwLCBzY2hlZHVsZSk7Cn0KClNUQVRJQyB2b2lk
Cnhmc19idWZfYmlvX2VuZF9pbygKCXN0cnVjdCBiaW8JCSpiaW8sCglpbnQJCQllcnJvcikKewoJ
eGZzX2J1Zl90CQkqYnAgPSAoeGZzX2J1Zl90ICopYmlvLT5iaV9wcml2YXRlOwoKCS8qCgkgKiBk
b24ndCBvdmVyd3JpdGUgZXhpc3RpbmcgZXJyb3JzIC0gb3RoZXJ3aXNlIHdlIGNhbiBsb3NlIGVy
cm9ycyBvbgoJICogYnVmZmVycyB0aGF0IHJlcXVpcmUgbXVsdGlwbGUgYmlvcyB0byBjb21wbGV0
ZS4KCSAqLwoJaWYgKCFicC0+Yl9lcnJvcikKCQl4ZnNfYnVmX2lvZXJyb3IoYnAsIC1lcnJvcik7
CgoJaWYgKCFicC0+Yl9lcnJvciAmJiB4ZnNfYnVmX2lzX3ZtYXBwZWQoYnApICYmIChicC0+Yl9m
bGFncyAmIFhCRl9SRUFEKSkKCQlpbnZhbGlkYXRlX2tlcm5lbF92bWFwX3JhbmdlKGJwLT5iX2Fk
ZHIsIHhmc19idWZfdm1hcF9sZW4oYnApKTsKCglfeGZzX2J1Zl9pb2VuZChicCwgMSk7CgliaW9f
cHV0KGJpbyk7Cn0KCnN0YXRpYyB2b2lkCnhmc19idWZfaW9hcHBseV9tYXAoCglzdHJ1Y3QgeGZz
X2J1ZgkqYnAsCglpbnQJCW1hcCwKCWludAkJKmJ1Zl9vZmZzZXQsCglpbnQJCSpjb3VudCwKCWlu
dAkJcncpCnsKCWludAkJcGFnZV9pbmRleDsKCWludAkJdG90YWxfbnJfcGFnZXMgPSBicC0+Yl9w
YWdlX2NvdW50OwoJaW50CQlucl9wYWdlczsKCXN0cnVjdCBiaW8JKmJpbzsKCXNlY3Rvcl90CXNl
Y3RvciA9ICBicC0+Yl9tYXBzW21hcF0uYm1fYm47CglpbnQJCXNpemU7CglpbnQJCW9mZnNldDsK
Cgl0b3RhbF9ucl9wYWdlcyA9IGJwLT5iX3BhZ2VfY291bnQ7CgoJLyogc2tpcCB0aGUgcGFnZXMg
aW4gdGhlIGJ1ZmZlciBiZWZvcmUgdGhlIHN0YXJ0IG9mZnNldCAqLwoJcGFnZV9pbmRleCA9IDA7
CglvZmZzZXQgPSAqYnVmX29mZnNldDsKCXdoaWxlIChvZmZzZXQgPj0gUEFHRV9TSVpFKSB7CgkJ
cGFnZV9pbmRleCsrOwoJCW9mZnNldCAtPSBQQUdFX1NJWkU7Cgl9CgoJLyoKCSAqIExpbWl0IHRo
ZSBJTyBzaXplIHRvIHRoZSBsZW5ndGggb2YgdGhlIGN1cnJlbnQgdmVjdG9yLCBhbmQgdXBkYXRl
IHRoZQoJICogcmVtYWluaW5nIElPIGNvdW50IGZvciB0aGUgbmV4dCB0aW1lIGFyb3VuZC4KCSAq
LwoJc2l6ZSA9IG1pbl90KGludCwgQkJUT0IoYnAtPmJfbWFwc1ttYXBdLmJtX2xlbiksICpjb3Vu
dCk7CgkqY291bnQgLT0gc2l6ZTsKCSpidWZfb2Zmc2V0ICs9IHNpemU7CgpuZXh0X2NodW5rOgoJ
YXRvbWljX2luYygmYnAtPmJfaW9fcmVtYWluaW5nKTsKCW5yX3BhZ2VzID0gQklPX01BWF9TRUNU
T1JTID4+IChQQUdFX1NISUZUIC0gQkJTSElGVCk7CglpZiAobnJfcGFnZXMgPiB0b3RhbF9ucl9w
YWdlcykKCQlucl9wYWdlcyA9IHRvdGFsX25yX3BhZ2VzOwoKCWJpbyA9IGJpb19hbGxvYyhHRlBf
Tk9JTywgbnJfcGFnZXMpOwoJYmlvLT5iaV9iZGV2ID0gYnAtPmJfdGFyZ2V0LT5idF9iZGV2OwoJ
YmlvLT5iaV9pdGVyLmJpX3NlY3RvciA9IHNlY3RvcjsKCWJpby0+YmlfZW5kX2lvID0geGZzX2J1
Zl9iaW9fZW5kX2lvOwoJYmlvLT5iaV9wcml2YXRlID0gYnA7CgoKCWZvciAoOyBzaXplICYmIG5y
X3BhZ2VzOyBucl9wYWdlcy0tLCBwYWdlX2luZGV4KyspIHsKCQlpbnQJcmJ5dGVzLCBuYnl0ZXMg
PSBQQUdFX1NJWkUgLSBvZmZzZXQ7CgoJCWlmIChuYnl0ZXMgPiBzaXplKQoJCQluYnl0ZXMgPSBz
aXplOwoKCQlyYnl0ZXMgPSBiaW9fYWRkX3BhZ2UoYmlvLCBicC0+Yl9wYWdlc1twYWdlX2luZGV4
XSwgbmJ5dGVzLAoJCQkJICAgICAgb2Zmc2V0KTsKCQlpZiAocmJ5dGVzIDwgbmJ5dGVzKQoJCQli
cmVhazsKCgkJb2Zmc2V0ID0gMDsKCQlzZWN0b3IgKz0gQlRPQkIobmJ5dGVzKTsKCQlzaXplIC09
IG5ieXRlczsKCQl0b3RhbF9ucl9wYWdlcy0tOwoJfQoKCWlmIChsaWtlbHkoYmlvLT5iaV9pdGVy
LmJpX3NpemUpKSB7CgkJaWYgKHhmc19idWZfaXNfdm1hcHBlZChicCkpIHsKCQkJZmx1c2hfa2Vy
bmVsX3ZtYXBfcmFuZ2UoYnAtPmJfYWRkciwKCQkJCQkJeGZzX2J1Zl92bWFwX2xlbihicCkpOwoJ
CX0KCQlzdWJtaXRfYmlvKHJ3LCBiaW8pOwoJCWlmIChzaXplKQoJCQlnb3RvIG5leHRfY2h1bms7
Cgl9IGVsc2UgewoJCS8qCgkJICogVGhpcyBpcyBndWFyYW50ZWVkIG5vdCB0byBiZSB0aGUgbGFz
dCBpbyByZWZlcmVuY2UgY291bnQKCQkgKiBiZWNhdXNlIHRoZSBjYWxsZXIgKHhmc19idWZfaW9y
ZXF1ZXN0KSBob2xkcyBhIGNvdW50IGl0c2VsZi4KCQkgKi8KCQlhdG9taWNfZGVjKCZicC0+Yl9p
b19yZW1haW5pbmcpOwoJCXhmc19idWZfaW9lcnJvcihicCwgRUlPKTsKCQliaW9fcHV0KGJpbyk7
Cgl9Cgp9CgpTVEFUSUMgdm9pZApfeGZzX2J1Zl9pb2FwcGx5KAoJc3RydWN0IHhmc19idWYJKmJw
KQp7CglzdHJ1Y3QgYmxrX3BsdWcJcGx1ZzsKCWludAkJcnc7CglpbnQJCW9mZnNldDsKCWludAkJ
c2l6ZTsKCWludAkJaTsKCgkvKgoJICogTWFrZSBzdXJlIHdlIGNhcHR1cmUgb25seSBjdXJyZW50
IElPIGVycm9ycyByYXRoZXIgdGhhbiBzdGFsZSBlcnJvcnMKCSAqIGxlZnQgb3ZlciBmcm9tIHBy
ZXZpb3VzIHVzZSBvZiB0aGUgYnVmZmVyIChlLmcuIGZhaWxlZCByZWFkYWhlYWQpLgoJICovCgli
cC0+Yl9lcnJvciA9IDA7CgoJaWYgKGJwLT5iX2ZsYWdzICYgWEJGX1dSSVRFKSB7CgkJaWYgKGJw
LT5iX2ZsYWdzICYgWEJGX1NZTkNJTykKCQkJcncgPSBXUklURV9TWU5DOwoJCWVsc2UKCQkJcncg
PSBXUklURTsKCQlpZiAoYnAtPmJfZmxhZ3MgJiBYQkZfRlVBKQoJCQlydyB8PSBSRVFfRlVBOwoJ
CWlmIChicC0+Yl9mbGFncyAmIFhCRl9GTFVTSCkKCQkJcncgfD0gUkVRX0ZMVVNIOwoKCQkvKgoJ
CSAqIFJ1biB0aGUgd3JpdGUgdmVyaWZpZXIgY2FsbGJhY2sgZnVuY3Rpb24gaWYgaXQgZXhpc3Rz
LiBJZgoJCSAqIHRoaXMgZnVuY3Rpb24gZmFpbHMgaXQgd2lsbCBtYXJrIHRoZSBidWZmZXIgd2l0
aCBhbiBlcnJvciBhbmQKCQkgKiB0aGUgSU8gc2hvdWxkIG5vdCBiZSBkaXNwYXRjaGVkLgoJCSAq
LwoJCWlmIChicC0+Yl9vcHMpIHsKCQkJYnAtPmJfb3BzLT52ZXJpZnlfd3JpdGUoYnApOwoJCQlp
ZiAoYnAtPmJfZXJyb3IpIHsKCQkJCXhmc19mb3JjZV9zaHV0ZG93bihicC0+Yl90YXJnZXQtPmJ0
X21vdW50LAoJCQkJCQkgICBTSFVURE9XTl9DT1JSVVBUX0lOQ09SRSk7CgkJCQlyZXR1cm47CgkJ
CX0KCQl9Cgl9IGVsc2UgaWYgKGJwLT5iX2ZsYWdzICYgWEJGX1JFQURfQUhFQUQpIHsKCQlydyA9
IFJFQURBOwoJfSBlbHNlIHsKCQlydyA9IFJFQUQ7Cgl9CgoJLyogd2Ugb25seSB1c2UgdGhlIGJ1
ZmZlciBjYWNoZSBmb3IgbWV0YS1kYXRhICovCglydyB8PSBSRVFfTUVUQTsKCgkvKgoJICogV2Fs
ayBhbGwgdGhlIHZlY3RvcnMgaXNzdWluZyBJTyBvbiB0aGVtLiBTZXQgdXAgdGhlIGluaXRpYWwg
b2Zmc2V0CgkgKiBpbnRvIHRoZSBidWZmZXIgYW5kIHRoZSBkZXNpcmVkIElPIHNpemUgYmVmb3Jl
IHdlIHN0YXJ0IC0KCSAqIF94ZnNfYnVmX2lvYXBwbHlfdmVjKCkgd2lsbCBtb2RpZnkgdGhlbSBh
cHByb3ByaWF0ZWx5IGZvciBlYWNoCgkgKiBzdWJzZXF1ZW50IGNhbGwuCgkgKi8KCW9mZnNldCA9
IGJwLT5iX29mZnNldDsKCXNpemUgPSBCQlRPQihicC0+Yl9pb19sZW5ndGgpOwoJYmxrX3N0YXJ0
X3BsdWcoJnBsdWcpOwoJZm9yIChpID0gMDsgaSA8IGJwLT5iX21hcF9jb3VudDsgaSsrKSB7CgkJ
eGZzX2J1Zl9pb2FwcGx5X21hcChicCwgaSwgJm9mZnNldCwgJnNpemUsIHJ3KTsKCQlpZiAoYnAt
PmJfZXJyb3IpCgkJCWJyZWFrOwoJCWlmIChzaXplIDw9IDApCgkJCWJyZWFrOwkvKiBhbGwgZG9u
ZSAqLwoJfQoJYmxrX2ZpbmlzaF9wbHVnKCZwbHVnKTsKfQoKdm9pZAp4ZnNfYnVmX2lvcmVxdWVz
dCgKCXhmc19idWZfdAkJKmJwKQp7Cgl0cmFjZV94ZnNfYnVmX2lvcmVxdWVzdChicCwgX1JFVF9J
UF8pOwoKCUFTU0VSVCghKGJwLT5iX2ZsYWdzICYgX1hCRl9ERUxXUklfUSkpOwoKCWlmIChicC0+
Yl9mbGFncyAmIFhCRl9XUklURSkKCQl4ZnNfYnVmX3dhaXRfdW5waW4oYnApOwoJeGZzX2J1Zl9o
b2xkKGJwKTsKCgkvKgoJICogU2V0IHRoZSBjb3VudCB0byAxIGluaXRpYWxseSwgdGhpcyB3aWxs
IHN0b3AgYW4gSS9PCgkgKiBjb21wbGV0aW9uIGNhbGxvdXQgd2hpY2ggaGFwcGVucyBiZWZvcmUg
d2UgaGF2ZSBzdGFydGVkCgkgKiBhbGwgdGhlIEkvTyBmcm9tIGNhbGxpbmcgeGZzX2J1Zl9pb2Vu
ZCB0b28gZWFybHkuCgkgKi8KCWF0b21pY19zZXQoJmJwLT5iX2lvX3JlbWFpbmluZywgMSk7Cglf
eGZzX2J1Zl9pb2FwcGx5KGJwKTsKCS8qCgkgKiBJZiBfeGZzX2J1Zl9pb2FwcGx5IGZhaWxlZCwg
d2UnbGwgZ2V0IGJhY2sgaGVyZSB3aXRoCgkgKiBvbmx5IHRoZSByZWZlcmVuY2Ugd2UgdG9vayBh
Ym92ZS4gIF94ZnNfYnVmX2lvZW5kIHdpbGwKCSAqIGRyb3AgaXQgdG8gemVybywgc28gd2UnZCBi
ZXR0ZXIgbm90IHF1ZXVlIGl0IGZvciBsYXRlciwKCSAqIG9yIHdlJ2xsIGZyZWUgaXQgYmVmb3Jl
IGl0J3MgZG9uZS4KCSAqLwoJX3hmc19idWZfaW9lbmQoYnAsIGJwLT5iX2Vycm9yID8gMCA6IDEp
OwoKCXhmc19idWZfcmVsZShicCk7Cn0KCi8qCiAqIFdhaXRzIGZvciBJL08gdG8gY29tcGxldGUg
b24gdGhlIGJ1ZmZlciBzdXBwbGllZC4gIEl0IHJldHVybnMgaW1tZWRpYXRlbHkgaWYKICogbm8g
SS9PIGlzIHBlbmRpbmcgb3IgdGhlcmUgaXMgYWxyZWFkeSBhIHBlbmRpbmcgZXJyb3Igb24gdGhl
IGJ1ZmZlciwgaW4gd2hpY2gKICogY2FzZSBub3RoaW5nIHdpbGwgZXZlciBjb21wbGV0ZS4gIEl0
IHJldHVybnMgdGhlIEkvTyBlcnJvciBjb2RlLCBpZiBhbnksIG9yCiAqIDAgaWYgdGhlcmUgd2Fz
IG5vIGVycm9yLgogKi8KaW50Cnhmc19idWZfaW93YWl0KAoJeGZzX2J1Zl90CQkqYnApCnsKCXRy
YWNlX3hmc19idWZfaW93YWl0KGJwLCBfUkVUX0lQXyk7CgoJaWYgKCFicC0+Yl9lcnJvcikKCQl3
YWl0X2Zvcl9jb21wbGV0aW9uKCZicC0+Yl9pb3dhaXQpOwoKCXRyYWNlX3hmc19idWZfaW93YWl0
X2RvbmUoYnAsIF9SRVRfSVBfKTsKCXJldHVybiBicC0+Yl9lcnJvcjsKfQoKeGZzX2NhZGRyX3QK
eGZzX2J1Zl9vZmZzZXQoCgl4ZnNfYnVmX3QJCSpicCwKCXNpemVfdAkJCW9mZnNldCkKewoJc3Ry
dWN0IHBhZ2UJCSpwYWdlOwoKCWlmIChicC0+Yl9hZGRyKQoJCXJldHVybiBicC0+Yl9hZGRyICsg
b2Zmc2V0OwoKCW9mZnNldCArPSBicC0+Yl9vZmZzZXQ7CglwYWdlID0gYnAtPmJfcGFnZXNbb2Zm
c2V0ID4+IFBBR0VfU0hJRlRdOwoJcmV0dXJuICh4ZnNfY2FkZHJfdClwYWdlX2FkZHJlc3MocGFn
ZSkgKyAob2Zmc2V0ICYgKFBBR0VfU0laRS0xKSk7Cn0KCi8qCiAqCU1vdmUgZGF0YSBpbnRvIG9y
IG91dCBvZiBhIGJ1ZmZlci4KICovCnZvaWQKeGZzX2J1Zl9pb21vdmUoCgl4ZnNfYnVmX3QJCSpi
cCwJLyogYnVmZmVyIHRvIHByb2Nlc3MJCSovCglzaXplX3QJCQlib2ZmLAkvKiBzdGFydGluZyBi
dWZmZXIgb2Zmc2V0CSovCglzaXplX3QJCQlic2l6ZSwJLyogbGVuZ3RoIHRvIGNvcHkJCSovCgl2
b2lkCQkJKmRhdGEsCS8qIGRhdGEgYWRkcmVzcwkJCSovCgl4ZnNfYnVmX3J3X3QJCW1vZGUpCS8q
IHJlYWQvd3JpdGUvemVybyBmbGFnCQkqLwp7CglzaXplX3QJCQliZW5kOwoKCWJlbmQgPSBib2Zm
ICsgYnNpemU7Cgl3aGlsZSAoYm9mZiA8IGJlbmQpIHsKCQlzdHJ1Y3QgcGFnZQkqcGFnZTsKCQlp
bnQJCXBhZ2VfaW5kZXgsIHBhZ2Vfb2Zmc2V0LCBjc2l6ZTsKCgkJcGFnZV9pbmRleCA9IChib2Zm
ICsgYnAtPmJfb2Zmc2V0KSA+PiBQQUdFX1NISUZUOwoJCXBhZ2Vfb2Zmc2V0ID0gKGJvZmYgKyBi
cC0+Yl9vZmZzZXQpICYgflBBR0VfTUFTSzsKCQlwYWdlID0gYnAtPmJfcGFnZXNbcGFnZV9pbmRl
eF07CgkJY3NpemUgPSBtaW5fdChzaXplX3QsIFBBR0VfU0laRSAtIHBhZ2Vfb2Zmc2V0LAoJCQkJ
ICAgICAgQkJUT0IoYnAtPmJfaW9fbGVuZ3RoKSAtIGJvZmYpOwoKCQlBU1NFUlQoKGNzaXplICsg
cGFnZV9vZmZzZXQpIDw9IFBBR0VfU0laRSk7CgoJCXN3aXRjaCAobW9kZSkgewoJCWNhc2UgWEJS
V19aRVJPOgoJCQltZW1zZXQocGFnZV9hZGRyZXNzKHBhZ2UpICsgcGFnZV9vZmZzZXQsIDAsIGNz
aXplKTsKCQkJYnJlYWs7CgkJY2FzZSBYQlJXX1JFQUQ6CgkJCW1lbWNweShkYXRhLCBwYWdlX2Fk
ZHJlc3MocGFnZSkgKyBwYWdlX29mZnNldCwgY3NpemUpOwoJCQlicmVhazsKCQljYXNlIFhCUldf
V1JJVEU6CgkJCW1lbWNweShwYWdlX2FkZHJlc3MocGFnZSkgKyBwYWdlX29mZnNldCwgZGF0YSwg
Y3NpemUpOwoJCX0KCgkJYm9mZiArPSBjc2l6ZTsKCQlkYXRhICs9IGNzaXplOwoJfQp9CgovKgog
KglIYW5kbGluZyBvZiBidWZmZXIgdGFyZ2V0cyAoYnVmdGFyZ3MpLgogKi8KCi8qCiAqIFdhaXQg
Zm9yIGFueSBidWZzIHdpdGggY2FsbGJhY2tzIHRoYXQgaGF2ZSBiZWVuIHN1Ym1pdHRlZCBidXQg
aGF2ZSBub3QgeWV0CiAqIHJldHVybmVkLiBUaGVzZSBidWZmZXJzIHdpbGwgaGF2ZSBhbiBlbGV2
YXRlZCBob2xkIGNvdW50LCBzbyB3YWl0IG9uIHRob3NlCiAqIHdoaWxlIGZyZWVpbmcgYWxsIHRo
ZSBidWZmZXJzIG9ubHkgaGVsZCBieSB0aGUgTFJVLgogKi8Kc3RhdGljIGVudW0gbHJ1X3N0YXR1
cwp4ZnNfYnVmdGFyZ193YWl0X3JlbGUoCglzdHJ1Y3QgbGlzdF9oZWFkCSppdGVtLAoJc3Bpbmxv
Y2tfdAkJKmxydV9sb2NrLAoJdm9pZAkJCSphcmcpCgp7CglzdHJ1Y3QgeGZzX2J1ZgkJKmJwID0g
Y29udGFpbmVyX29mKGl0ZW0sIHN0cnVjdCB4ZnNfYnVmLCBiX2xydSk7CglzdHJ1Y3QgbGlzdF9o
ZWFkCSpkaXNwb3NlID0gYXJnOwoKCWlmIChhdG9taWNfcmVhZCgmYnAtPmJfaG9sZCkgPiAxKSB7
CgkJLyogbmVlZCB0byB3YWl0LCBzbyBza2lwIGl0IHRoaXMgcGFzcyAqLwoJCXRyYWNlX3hmc19i
dWZfd2FpdF9idWZ0YXJnKGJwLCBfUkVUX0lQXyk7CgkJcmV0dXJuIExSVV9TS0lQOwoJfQoJaWYg
KCFzcGluX3RyeWxvY2soJmJwLT5iX2xvY2spKQoJCXJldHVybiBMUlVfU0tJUDsKCgkvKgoJICog
Y2xlYXIgdGhlIExSVSByZWZlcmVuY2UgY291bnQgc28gdGhlIGJ1ZmZlciBkb2Vzbid0IGdldAoJ
ICogaWdub3JlZCBpbiB4ZnNfYnVmX3JlbGUoKS4KCSAqLwoJYXRvbWljX3NldCgmYnAtPmJfbHJ1
X3JlZiwgMCk7CglicC0+Yl9zdGF0ZSB8PSBYRlNfQlNUQVRFX0RJU1BPU0U7CglsaXN0X21vdmUo
aXRlbSwgZGlzcG9zZSk7CglzcGluX3VubG9jaygmYnAtPmJfbG9jayk7CglyZXR1cm4gTFJVX1JF
TU9WRUQ7Cn0KCnZvaWQKeGZzX3dhaXRfYnVmdGFyZygKCXN0cnVjdCB4ZnNfYnVmdGFyZwkqYnRw
KQp7CglMSVNUX0hFQUQoZGlzcG9zZSk7CglpbnQgbG9vcCA9IDA7CgoJLyogbG9vcCB1bnRpbCB0
aGVyZSBpcyBub3RoaW5nIGxlZnQgb24gdGhlIGxydSBsaXN0LiAqLwoJd2hpbGUgKGxpc3RfbHJ1
X2NvdW50KCZidHAtPmJ0X2xydSkpIHsKCQlsaXN0X2xydV93YWxrKCZidHAtPmJ0X2xydSwgeGZz
X2J1ZnRhcmdfd2FpdF9yZWxlLAoJCQkgICAgICAmZGlzcG9zZSwgTE9OR19NQVgpOwoKCQl3aGls
ZSAoIWxpc3RfZW1wdHkoJmRpc3Bvc2UpKSB7CgkJCXN0cnVjdCB4ZnNfYnVmICpicDsKCQkJYnAg
PSBsaXN0X2ZpcnN0X2VudHJ5KCZkaXNwb3NlLCBzdHJ1Y3QgeGZzX2J1ZiwgYl9scnUpOwoJCQls
aXN0X2RlbF9pbml0KCZicC0+Yl9scnUpOwoJCQlpZiAoYnAtPmJfZmxhZ3MgJiBYQkZfV1JJVEVf
RkFJTCkgewoJCQkJeGZzX2FsZXJ0KGJ0cC0+YnRfbW91bnQsCiJDb3JydXB0aW9uIEFsZXJ0OiBC
dWZmZXIgYXQgYmxvY2sgMHglbGx4IGhhZCBwZXJtYW5lbnQgd3JpdGUgZmFpbHVyZXMhXG4iCiJQ
bGVhc2UgcnVuIHhmc19yZXBhaXIgdG8gZGV0ZXJtaW5lIHRoZSBleHRlbnQgb2YgdGhlIHByb2Js
ZW0uIiwKCQkJCQkobG9uZyBsb25nKWJwLT5iX2JuKTsKCQkJfQoJCQl4ZnNfYnVmX3JlbGUoYnAp
OwoJCX0KCQlpZiAobG9vcCsrICE9IDApCgkJCWRlbGF5KDEwMCk7Cgl9Cn0KCnN0YXRpYyBlbnVt
IGxydV9zdGF0dXMKeGZzX2J1ZnRhcmdfaXNvbGF0ZSgKCXN0cnVjdCBsaXN0X2hlYWQJKml0ZW0s
CglzcGlubG9ja190CQkqbHJ1X2xvY2ssCgl2b2lkCQkJKmFyZykKewoJc3RydWN0IHhmc19idWYJ
CSpicCA9IGNvbnRhaW5lcl9vZihpdGVtLCBzdHJ1Y3QgeGZzX2J1ZiwgYl9scnUpOwoJc3RydWN0
IGxpc3RfaGVhZAkqZGlzcG9zZSA9IGFyZzsKCgkvKgoJICogd2UgYXJlIGludmVydGluZyB0aGUg
bHJ1IGxvY2svYnAtPmJfbG9jayBoZXJlLCBzbyB1c2UgYSB0cnlsb2NrLgoJICogSWYgd2UgZmFp
bCB0byBnZXQgdGhlIGxvY2ssIGp1c3Qgc2tpcCBpdC4KCSAqLwoJaWYgKCFzcGluX3RyeWxvY2so
JmJwLT5iX2xvY2spKQoJCXJldHVybiBMUlVfU0tJUDsKCS8qCgkgKiBEZWNyZW1lbnQgdGhlIGJf
bHJ1X3JlZiBjb3VudCB1bmxlc3MgdGhlIHZhbHVlIGlzIGFscmVhZHkKCSAqIHplcm8uIElmIHRo
ZSB2YWx1ZSBpcyBhbHJlYWR5IHplcm8sIHdlIG5lZWQgdG8gcmVjbGFpbSB0aGUKCSAqIGJ1ZmZl
ciwgb3RoZXJ3aXNlIGl0IGdldHMgYW5vdGhlciB0cmlwIHRocm91Z2ggdGhlIExSVS4KCSAqLwoJ
aWYgKCFhdG9taWNfYWRkX3VubGVzcygmYnAtPmJfbHJ1X3JlZiwgLTEsIDApKSB7CgkJc3Bpbl91
bmxvY2soJmJwLT5iX2xvY2spOwoJCXJldHVybiBMUlVfUk9UQVRFOwoJfQoKCWJwLT5iX3N0YXRl
IHw9IFhGU19CU1RBVEVfRElTUE9TRTsKCWxpc3RfbW92ZShpdGVtLCBkaXNwb3NlKTsKCXNwaW5f
dW5sb2NrKCZicC0+Yl9sb2NrKTsKCXJldHVybiBMUlVfUkVNT1ZFRDsKfQoKc3RhdGljIHVuc2ln
bmVkIGxvbmcKeGZzX2J1ZnRhcmdfc2hyaW5rX3NjYW4oCglzdHJ1Y3Qgc2hyaW5rZXIJCSpzaHJp
bmssCglzdHJ1Y3Qgc2hyaW5rX2NvbnRyb2wJKnNjKQp7CglzdHJ1Y3QgeGZzX2J1ZnRhcmcJKmJ0
cCA9IGNvbnRhaW5lcl9vZihzaHJpbmssCgkJCQkJc3RydWN0IHhmc19idWZ0YXJnLCBidF9zaHJp
bmtlcik7CglMSVNUX0hFQUQoZGlzcG9zZSk7Cgl1bnNpZ25lZCBsb25nCQlmcmVlZDsKCXVuc2ln
bmVkIGxvbmcJCW5yX3RvX3NjYW4gPSBzYy0+bnJfdG9fc2NhbjsKCglmcmVlZCA9IGxpc3RfbHJ1
X3dhbGtfbm9kZSgmYnRwLT5idF9scnUsIHNjLT5uaWQsIHhmc19idWZ0YXJnX2lzb2xhdGUsCgkJ
CQkgICAgICAgJmRpc3Bvc2UsICZucl90b19zY2FuKTsKCgl3aGlsZSAoIWxpc3RfZW1wdHkoJmRp
c3Bvc2UpKSB7CgkJc3RydWN0IHhmc19idWYgKmJwOwoJCWJwID0gbGlzdF9maXJzdF9lbnRyeSgm
ZGlzcG9zZSwgc3RydWN0IHhmc19idWYsIGJfbHJ1KTsKCQlsaXN0X2RlbF9pbml0KCZicC0+Yl9s
cnUpOwoJCXhmc19idWZfcmVsZShicCk7Cgl9CgoJcmV0dXJuIGZyZWVkOwp9CgpzdGF0aWMgdW5z
aWduZWQgbG9uZwp4ZnNfYnVmdGFyZ19zaHJpbmtfY291bnQoCglzdHJ1Y3Qgc2hyaW5rZXIJCSpz
aHJpbmssCglzdHJ1Y3Qgc2hyaW5rX2NvbnRyb2wJKnNjKQp7CglzdHJ1Y3QgeGZzX2J1ZnRhcmcJ
KmJ0cCA9IGNvbnRhaW5lcl9vZihzaHJpbmssCgkJCQkJc3RydWN0IHhmc19idWZ0YXJnLCBidF9z
aHJpbmtlcik7CglyZXR1cm4gbGlzdF9scnVfY291bnRfbm9kZSgmYnRwLT5idF9scnUsIHNjLT5u
aWQpOwp9Cgp2b2lkCnhmc19mcmVlX2J1ZnRhcmcoCglzdHJ1Y3QgeGZzX21vdW50CSptcCwKCXN0
cnVjdCB4ZnNfYnVmdGFyZwkqYnRwKQp7Cgl1bnJlZ2lzdGVyX3Nocmlua2VyKCZidHAtPmJ0X3No
cmlua2VyKTsKCWxpc3RfbHJ1X2Rlc3Ryb3koJmJ0cC0+YnRfbHJ1KTsKCglpZiAobXAtPm1fZmxh
Z3MgJiBYRlNfTU9VTlRfQkFSUklFUikKCQl4ZnNfYmxrZGV2X2lzc3VlX2ZsdXNoKGJ0cCk7CgoJ
a21lbV9mcmVlKGJ0cCk7Cn0KCmludAp4ZnNfc2V0c2l6ZV9idWZ0YXJnKAoJeGZzX2J1ZnRhcmdf
dAkJKmJ0cCwKCXVuc2lnbmVkIGludAkJc2VjdG9yc2l6ZSkKewoJLyogU2V0IHVwIG1ldGFkYXRh
IHNlY3RvciBzaXplIGluZm8gKi8KCWJ0cC0+YnRfbWV0YV9zZWN0b3JzaXplID0gc2VjdG9yc2l6
ZTsKCWJ0cC0+YnRfbWV0YV9zZWN0b3JtYXNrID0gc2VjdG9yc2l6ZSAtIDE7CgoJaWYgKHNldF9i
bG9ja3NpemUoYnRwLT5idF9iZGV2LCBzZWN0b3JzaXplKSkgewoJCWNoYXIgbmFtZVtCREVWTkFN
RV9TSVpFXTsKCgkJYmRldm5hbWUoYnRwLT5idF9iZGV2LCBuYW1lKTsKCgkJeGZzX3dhcm4oYnRw
LT5idF9tb3VudCwKCQkJIkNhbm5vdCBzZXRfYmxvY2tzaXplIHRvICV1IG9uIGRldmljZSAlcyIs
CgkJCXNlY3RvcnNpemUsIG5hbWUpOwoJCXJldHVybiBFSU5WQUw7Cgl9CgoJLyogU2V0IHVwIGRl
dmljZSBsb2dpY2FsIHNlY3RvciBzaXplIG1hc2sgKi8KCWJ0cC0+YnRfbG9naWNhbF9zZWN0b3Jz
aXplID0gYmRldl9sb2dpY2FsX2Jsb2NrX3NpemUoYnRwLT5idF9iZGV2KTsKCWJ0cC0+YnRfbG9n
aWNhbF9zZWN0b3JtYXNrID0gYmRldl9sb2dpY2FsX2Jsb2NrX3NpemUoYnRwLT5idF9iZGV2KSAt
IDE7CgoJcmV0dXJuIDA7Cn0KCi8qCiAqIFdoZW4gYWxsb2NhdGluZyB0aGUgaW5pdGlhbCBidWZm
ZXIgdGFyZ2V0IHdlIGhhdmUgbm90IHlldAogKiByZWFkIGluIHRoZSBzdXBlcmJsb2NrLCBzbyBk
b24ndCBrbm93IHdoYXQgc2l6ZWQgc2VjdG9ycwogKiBhcmUgYmVpbmcgdXNlZCBhdCB0aGlzIGVh
cmx5IHN0YWdlLiAgUGxheSBzYWZlLgogKi8KU1RBVElDIGludAp4ZnNfc2V0c2l6ZV9idWZ0YXJn
X2Vhcmx5KAoJeGZzX2J1ZnRhcmdfdAkJKmJ0cCwKCXN0cnVjdCBibG9ja19kZXZpY2UJKmJkZXYp
CnsKCXJldHVybiB4ZnNfc2V0c2l6ZV9idWZ0YXJnKGJ0cCwgYmRldl9sb2dpY2FsX2Jsb2NrX3Np
emUoYmRldikpOwp9Cgp4ZnNfYnVmdGFyZ190ICoKeGZzX2FsbG9jX2J1ZnRhcmcoCglzdHJ1Y3Qg
eGZzX21vdW50CSptcCwKCXN0cnVjdCBibG9ja19kZXZpY2UJKmJkZXYpCnsKCXhmc19idWZ0YXJn
X3QJCSpidHA7CgoJYnRwID0ga21lbV96YWxsb2Moc2l6ZW9mKCpidHApLCBLTV9TTEVFUCB8IEtN
X05PRlMpOwoKCWJ0cC0+YnRfbW91bnQgPSBtcDsKCWJ0cC0+YnRfZGV2ID0gIGJkZXYtPmJkX2Rl
djsKCWJ0cC0+YnRfYmRldiA9IGJkZXY7CglidHAtPmJ0X2JkaSA9IGJsa19nZXRfYmFja2luZ19k
ZXZfaW5mbyhiZGV2KTsKCWlmICghYnRwLT5idF9iZGkpCgkJZ290byBlcnJvcjsKCglpZiAoeGZz
X3NldHNpemVfYnVmdGFyZ19lYXJseShidHAsIGJkZXYpKQoJCWdvdG8gZXJyb3I7CgoJaWYgKGxp
c3RfbHJ1X2luaXQoJmJ0cC0+YnRfbHJ1KSkKCQlnb3RvIGVycm9yOwoKCWJ0cC0+YnRfc2hyaW5r
ZXIuY291bnRfb2JqZWN0cyA9IHhmc19idWZ0YXJnX3Nocmlua19jb3VudDsKCWJ0cC0+YnRfc2hy
aW5rZXIuc2Nhbl9vYmplY3RzID0geGZzX2J1ZnRhcmdfc2hyaW5rX3NjYW47CglidHAtPmJ0X3No
cmlua2VyLnNlZWtzID0gREVGQVVMVF9TRUVLUzsKCWJ0cC0+YnRfc2hyaW5rZXIuZmxhZ3MgPSBT
SFJJTktFUl9OVU1BX0FXQVJFOwoJcmVnaXN0ZXJfc2hyaW5rZXIoJmJ0cC0+YnRfc2hyaW5rZXIp
OwoJcmV0dXJuIGJ0cDsKCmVycm9yOgoJa21lbV9mcmVlKGJ0cCk7CglyZXR1cm4gTlVMTDsKfQoK
LyoKICogQWRkIGEgYnVmZmVyIHRvIHRoZSBkZWxheWVkIHdyaXRlIGxpc3QuCiAqCiAqIFRoaXMg
cXVldWVzIGEgYnVmZmVyIGZvciB3cml0ZW91dCBpZiBpdCBoYXNuJ3QgYWxyZWFkeSBiZWVuLiAg
Tm90ZSB0aGF0CiAqIG5laXRoZXIgdGhpcyByb3V0aW5lIG5vciB0aGUgYnVmZmVyIGxpc3Qgc3Vi
bWlzc2lvbiBmdW5jdGlvbnMgcGVyZm9ybQogKiBhbnkgaW50ZXJuYWwgc3luY2hyb25pemF0aW9u
LiAgSXQgaXMgZXhwZWN0ZWQgdGhhdCB0aGUgbGlzdHMgYXJlIHRocmVhZC1sb2NhbAogKiB0byB0
aGUgY2FsbGVycy4KICoKICogUmV0dXJucyB0cnVlIGlmIHdlIHF1ZXVlZCB1cCB0aGUgYnVmZmVy
LCBvciBmYWxzZSBpZiBpdCBhbHJlYWR5IGhhZAogKiBiZWVuIG9uIHRoZSBidWZmZXIgbGlzdC4K
ICovCmJvb2wKeGZzX2J1Zl9kZWx3cmlfcXVldWUoCglzdHJ1Y3QgeGZzX2J1ZgkJKmJwLAoJc3Ry
dWN0IGxpc3RfaGVhZAkqbGlzdCkKewoJQVNTRVJUKHhmc19idWZfaXNsb2NrZWQoYnApKTsKCUFT
U0VSVCghKGJwLT5iX2ZsYWdzICYgWEJGX1JFQUQpKTsKCgkvKgoJICogSWYgdGhlIGJ1ZmZlciBp
cyBhbHJlYWR5IG1hcmtlZCBkZWx3cmkgaXQgYWxyZWFkeSBpcyBxdWV1ZWQgdXAKCSAqIGJ5IHNv
bWVvbmUgZWxzZSBmb3IgaW1lZGlhdGUgd3JpdGVvdXQuICBKdXN0IGlnbm9yZSBpdCBpbiB0aGF0
CgkgKiBjYXNlLgoJICovCglpZiAoYnAtPmJfZmxhZ3MgJiBfWEJGX0RFTFdSSV9RKSB7CgkJdHJh
Y2VfeGZzX2J1Zl9kZWx3cmlfcXVldWVkKGJwLCBfUkVUX0lQXyk7CgkJcmV0dXJuIGZhbHNlOwoJ
fQoKCXRyYWNlX3hmc19idWZfZGVsd3JpX3F1ZXVlKGJwLCBfUkVUX0lQXyk7CgoJLyoKCSAqIElm
IGEgYnVmZmVyIGdldHMgd3JpdHRlbiBvdXQgc3luY2hyb25vdXNseSBvciBtYXJrZWQgc3RhbGUg
d2hpbGUgaXQKCSAqIGlzIG9uIGEgZGVsd3JpIGxpc3Qgd2UgbGF6aWx5IHJlbW92ZSBpdC4gVG8g
ZG8gdGhpcywgdGhlIG90aGVyIHBhcnR5CgkgKiBjbGVhcnMgdGhlICBfWEJGX0RFTFdSSV9RIGZs
YWcgYnV0IG90aGVyd2lzZSBsZWF2ZXMgdGhlIGJ1ZmZlciBhbG9uZS4KCSAqIEl0IHJlbWFpbnMg
cmVmZXJlbmNlZCBhbmQgb24gdGhlIGxpc3QuICBJbiBhIHJhcmUgY29ybmVyIGNhc2UgaXQKCSAq
IG1pZ2h0IGdldCByZWFkZGVkIHRvIGEgZGVsd3JpIGxpc3QgYWZ0ZXIgdGhlIHN5bmNocm9ub3Vz
IHdyaXRlb3V0LCBpbgoJICogd2hpY2ggY2FzZSB3ZSBuZWVkIGp1c3QgbmVlZCB0byByZS1hZGQg
dGhlIGZsYWcgaGVyZS4KCSAqLwoJYnAtPmJfZmxhZ3MgfD0gX1hCRl9ERUxXUklfUTsKCWlmIChs
aXN0X2VtcHR5KCZicC0+Yl9saXN0KSkgewoJCWF0b21pY19pbmMoJmJwLT5iX2hvbGQpOwoJCWxp
c3RfYWRkX3RhaWwoJmJwLT5iX2xpc3QsIGxpc3QpOwoJfQoKCXJldHVybiB0cnVlOwp9CgovKgog
KiBDb21wYXJlIGZ1bmN0aW9uIGlzIG1vcmUgY29tcGxleCB0aGFuIGl0IG5lZWRzIHRvIGJlIGJl
Y2F1c2UKICogdGhlIHJldHVybiB2YWx1ZSBpcyBvbmx5IDMyIGJpdHMgYW5kIHdlIGFyZSBkb2lu
ZyBjb21wYXJpc29ucwogKiBvbiA2NCBiaXQgdmFsdWVzCiAqLwpzdGF0aWMgaW50Cnhmc19idWZf
Y21wKAoJdm9pZAkJKnByaXYsCglzdHJ1Y3QgbGlzdF9oZWFkICphLAoJc3RydWN0IGxpc3RfaGVh
ZCAqYikKewoJc3RydWN0IHhmc19idWYJKmFwID0gY29udGFpbmVyX29mKGEsIHN0cnVjdCB4ZnNf
YnVmLCBiX2xpc3QpOwoJc3RydWN0IHhmc19idWYJKmJwID0gY29udGFpbmVyX29mKGIsIHN0cnVj
dCB4ZnNfYnVmLCBiX2xpc3QpOwoJeGZzX2RhZGRyX3QJCWRpZmY7CgoJZGlmZiA9IGFwLT5iX21h
cHNbMF0uYm1fYm4gLSBicC0+Yl9tYXBzWzBdLmJtX2JuOwoJaWYgKGRpZmYgPCAwKQoJCXJldHVy
biAtMTsKCWlmIChkaWZmID4gMCkKCQlyZXR1cm4gMTsKCXJldHVybiAwOwp9CgoKc3RhdGljIHZv
aWQKeGZzX2J1Zl9kZWx3cmlfc3VibWl0X2J1ZmZlcnMoCiAgICAgICBzdHJ1Y3QgbGlzdF9oZWFk
ICAgICAgICAqYnVmZmVyX2xpc3QsCiAgICAgICBib29sICAgICAgICAgICAgICAgICAgICB3YWl0
KQp7CiAgICAgICBzdHJ1Y3QgeGZzX2J1ZiAgICAgICAgICAqYnAsICpuOwogICAgICAgc3RydWN0
IGJsa19wbHVnICAgICAgICAgcGx1ZzsKCiAgICAgICBibGtfc3RhcnRfcGx1ZygmcGx1Zyk7CiAg
ICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoYnAsIG4sIGJ1ZmZlcl9saXN0LCBiX2xpc3Qp
IHsKICAgICAgICAgICBicC0+Yl9mbGFncyAmPSB+KF9YQkZfREVMV1JJX1EgfCBYQkZfQVNZTkMg
fCBYQkZfV1JJVEVfRkFJTCk7CiAJICAgYnAtPmJfZmxhZ3MgfD0gWEJGX1dSSVRFOwoKCSAgIGlm
ICghd2FpdCkgewogCSAgICAgICBicC0+Yl9mbGFncyB8PSBYQkZfQVNZTkM7CgkgICAgICAgbGlz
dF9kZWxfaW5pdCgmYnAtPmJfbGlzdCk7CgkgICB9CiAgICAgICAgICAgeGZzX2Jkc3RyYXRfY2Io
YnApOwoJfQoJYmxrX2ZpbmlzaF9wbHVnKCZwbHVnKTsKfQoKCnN0YXRpYyBpbnQKX194ZnNfYnVm
X2RlbHdyaV9zdWJtaXQoCglzdHJ1Y3QgbGlzdF9oZWFkCSpidWZmZXJfbGlzdCwKCXN0cnVjdCBs
aXN0X2hlYWQJKmlvX2xpc3QsCglib29sCQkJd2FpdCkKewoJc3RydWN0IHhmc19idWYJCSpicCwg
Km47CglpbnQJCQlwaW5uZWQgPSAwOwogICAgICAgIExJU1RfSEVBRCAgICAgICAgICAgICAgIChz
dWJtaXRfbGlzdCk7CiAgICAgICAgaW50ICAgICAgICAgICAgICAgICAgICAgY291bnQgPSAwOwoK
ICAgICAgICBsaXN0X3NvcnQoTlVMTCwgYnVmZmVyX2xpc3QsIHhmc19idWZfY21wKTsKCglsaXN0
X2Zvcl9lYWNoX2VudHJ5X3NhZmUoYnAsIG4sIGJ1ZmZlcl9saXN0LCBiX2xpc3QpIHsKCQlpZiAo
IXdhaXQpIHsKCQkJaWYgKHhmc19idWZfaXNwaW5uZWQoYnApKSB7CgkJCQlwaW5uZWQrKzsKCQkJ
CWNvbnRpbnVlOwoJCQl9CgkJCWlmICgheGZzX2J1Zl90cnlsb2NrKGJwKSkKCQkJCWNvbnRpbnVl
OwoJCX0gZWxzZSB7CgkJCXhmc19idWZfbG9jayhicCk7CgkJfQoKCQkvKgoJCSAqIFNvbWVvbmUg
ZWxzZSBtaWdodCBoYXZlIHdyaXR0ZW4gdGhlIGJ1ZmZlciBzeW5jaHJvbm91c2x5IG9yCgkJICog
bWFya2VkIGl0IHN0YWxlIGluIHRoZSBtZWFudGltZS4gIEluIHRoYXQgY2FzZSBvbmx5IHRoZQoJ
CSAqIF9YQkZfREVMV1JJX1EgZmxhZyBnb3QgY2xlYXJlZCwgYW5kIHdlIGhhdmUgdG8gZHJvcCB0
aGUKCQkgKiByZWZlcmVuY2UgYW5kIHJlbW92ZSBpdCBmcm9tIHRoZSBsaXN0IGhlcmUuCgkJICov
CgkJaWYgKCEoYnAtPmJfZmxhZ3MgJiBfWEJGX0RFTFdSSV9RKSkgewoJCQlsaXN0X2RlbF9pbml0
KCZicC0+Yl9saXN0KTsKCQkJeGZzX2J1Zl9yZWxzZShicCk7CgkJCWNvbnRpbnVlOwoJCX0KCgkJ
Ly9saXN0X21vdmVfdGFpbCgmYnAtPmJfbGlzdCwgaW9fbGlzdCk7CiAgICAgICAgICAgICAgICBs
aXN0X21vdmVfdGFpbCgmYnAtPmJfbGlzdCwgJnN1Ym1pdF9saXN0KTsKCQl0cmFjZV94ZnNfYnVm
X2RlbHdyaV9zcGxpdChicCwgX1JFVF9JUF8pOwogICAgICAgICAgICAgICAgaWYgKGNvdW50Kysg
PCA1MCkgewogICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOwogICAgICAgICAgICAgICAgfQoK
ICAgICAgICAgICAgICAgIHhmc19idWZfZGVsd3JpX3N1Ym1pdF9idWZmZXJzKCZzdWJtaXRfbGlz
dCwgd2FpdCk7CiAgICAgICAgICAgICAgICBjb3VudCA9IDA7Cgl9CgoJLy8gbGlzdF9zb3J0KE5V
TEwsIGlvX2xpc3QsIHhmc19idWZfY21wKTsKCiAgICAgICAgaWYgKCFsaXN0X2VtcHR5KCZzdWJt
aXRfbGlzdCkpIHsKICAgICAgICAgICAgeGZzX2J1Zl9kZWx3cmlfc3VibWl0X2J1ZmZlcnMoJnN1
Ym1pdF9saXN0LCB3YWl0KTsKICAgICAgICB9CgoJcmV0dXJuIHBpbm5lZDsKfQoKLyoKICogV3Jp
dGUgb3V0IGEgYnVmZmVyIGxpc3QgYXN5bmNocm9ub3VzbHkuCiAqCiAqIFRoaXMgd2lsbCB0YWtl
IHRoZSBAYnVmZmVyX2xpc3QsIHdyaXRlIGFsbCBub24tbG9ja2VkIGFuZCBub24tcGlubmVkIGJ1
ZmZlcnMKICogb3V0IGFuZCBub3Qgd2FpdCBmb3IgSS9PIGNvbXBsZXRpb24gb24gYW55IG9mIHRo
ZSBidWZmZXJzLiAgVGhpcyBpbnRlcmZhY2UKICogaXMgb25seSBzYWZlbHkgdXNlYWJsZSBmb3Ig
Y2FsbGVycyB0aGF0IGNhbiB0cmFjayBJL08gY29tcGxldGlvbiBieSBoaWdoZXIKICogbGV2ZWwg
bWVhbnMsIGUuZy4gQUlMIHB1c2hpbmcgYXMgdGhlIEBidWZmZXJfbGlzdCBpcyBjb25zdW1lZCBp
biB0aGlzCiAqIGZ1bmN0aW9uLgogKi8KaW50Cnhmc19idWZfZGVsd3JpX3N1Ym1pdF9ub3dhaXQo
CglzdHJ1Y3QgbGlzdF9oZWFkCSpidWZmZXJfbGlzdCkKewoJTElTVF9IRUFECQkoaW9fbGlzdCk7
CglyZXR1cm4gX194ZnNfYnVmX2RlbHdyaV9zdWJtaXQoYnVmZmVyX2xpc3QsICZpb19saXN0LCBm
YWxzZSk7Cn0KCi8qCiAqIFdyaXRlIG91dCBhIGJ1ZmZlciBsaXN0IHN5bmNocm9ub3VzbHkuCiAq
CiAqIFRoaXMgd2lsbCB0YWtlIHRoZSBAYnVmZmVyX2xpc3QsIHdyaXRlIGFsbCBidWZmZXJzIG91
dCBhbmQgd2FpdCBmb3IgSS9PCiAqIGNvbXBsZXRpb24gb24gYWxsIG9mIHRoZSBidWZmZXJzLiBA
YnVmZmVyX2xpc3QgaXMgY29uc3VtZWQgYnkgdGhlIGZ1bmN0aW9uLAogKiBzbyBjYWxsZXJzIG11
c3QgaGF2ZSBzb21lIG90aGVyIHdheSBvZiB0cmFja2luZyBidWZmZXJzIGlmIHRoZXkgcmVxdWly
ZSBzdWNoCiAqIGZ1bmN0aW9uYWxpdHkuCiAqLwppbnQKeGZzX2J1Zl9kZWx3cmlfc3VibWl0KAoJ
c3RydWN0IGxpc3RfaGVhZAkqYnVmZmVyX2xpc3QpCnsKCUxJU1RfSEVBRAkJKGlvX2xpc3QpOwoJ
aW50CQkJZXJyb3IgPSAwLCBlcnJvcjI7CglzdHJ1Y3QgeGZzX2J1ZgkJKmJwOwoKCV9feGZzX2J1
Zl9kZWx3cmlfc3VibWl0KGJ1ZmZlcl9saXN0LCAmaW9fbGlzdCwgdHJ1ZSk7CgoJLyogV2FpdCBm
b3IgSU8gdG8gY29tcGxldGUuICovCgl3aGlsZSAoIWxpc3RfZW1wdHkoJmlvX2xpc3QpKSB7CgkJ
YnAgPSBsaXN0X2ZpcnN0X2VudHJ5KCZpb19saXN0LCBzdHJ1Y3QgeGZzX2J1ZiwgYl9saXN0KTsK
CgkJbGlzdF9kZWxfaW5pdCgmYnAtPmJfbGlzdCk7CgkJZXJyb3IyID0geGZzX2J1Zl9pb3dhaXQo
YnApOwoJCXhmc19idWZfcmVsc2UoYnApOwoJCWlmICghZXJyb3IpCgkJCWVycm9yID0gZXJyb3Iy
OwoJfQoKCXJldHVybiBlcnJvcjsKfQoKaW50IF9faW5pdAp4ZnNfYnVmX2luaXQodm9pZCkKewoJ
eGZzX2J1Zl96b25lID0ga21lbV96b25lX2luaXRfZmxhZ3Moc2l6ZW9mKHhmc19idWZfdCksICJ4
ZnNfYnVmIiwKCQkJCQkJS01fWk9ORV9IV0FMSUdOLCBOVUxMKTsKCWlmICgheGZzX2J1Zl96b25l
KQoJCWdvdG8gb3V0OwoKCXhmc2xvZ2Rfd29ya3F1ZXVlID0gYWxsb2Nfd29ya3F1ZXVlKCJ4ZnNs
b2dkIiwKCQkJCQlXUV9NRU1fUkVDTEFJTSB8IFdRX0hJR0hQUkksIDEpOwoJaWYgKCF4ZnNsb2dk
X3dvcmtxdWV1ZSkKCQlnb3RvIG91dF9mcmVlX2J1Zl96b25lOwoKCXJldHVybiAwOwoKIG91dF9m
cmVlX2J1Zl96b25lOgoJa21lbV96b25lX2Rlc3Ryb3koeGZzX2J1Zl96b25lKTsKIG91dDoKCXJl
dHVybiAtRU5PTUVNOwp9Cgp2b2lkCnhmc19idWZfdGVybWluYXRlKHZvaWQpCnsKCWRlc3Ryb3lf
d29ya3F1ZXVlKHhmc2xvZ2Rfd29ya3F1ZXVlKTsKCWttZW1fem9uZV9kZXN0cm95KHhmc19idWZf
em9uZSk7Cn0K
--001a11c1635eb7430e051808b52f
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--001a11c1635eb7430e051808b52f--
