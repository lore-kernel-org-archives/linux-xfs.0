Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 19:24:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9J2OCaG031816
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 19:24:13 -0700
Message-ID: <4536E186.5040301@ah.jp.nec.com>
Date: Thu, 19 Oct 2006 11:23:02 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
MIME-Version: 1.0
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com> <20061013014651.GC19345@melbourne.sgi.com> <452F83BD.8050501@ah.jp.nec.com> <20061017020218.GE8394166@melbourne.sgi.com> <20061018023325.GL8394166@melbourne.sgi.com> <20061018090701.GU11034@melbourne.sgi.com>
In-Reply-To: <20061018090701.GU11034@melbourne.sgi.com>
Content-Type: multipart/mixed;
 boundary="------------020703010704010900070501"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020703010704010900070501
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi David,

I'm testing your three patches.
I am not seeing any degradation with your patches.

But I think the patch that I attach to this mail is necessary.
Isn't it?

David Chinner wrote:
> On Wed, Oct 18, 2006 at 12:33:25PM +1000, David Chinner wrote:
>> On Tue, Oct 17, 2006 at 12:02:18PM +1000, David Chinner wrote:
>>> So, here's another patch that doesn't have the performance problems,
>>> but removes the iput/igrab while still (I think) fixing the use
>>> after free problem. Can you try this one out, Takenori? I've
>>> run it through some stress tests and haven't been able to trigger
>>> problems.
>> I just hit the BUG_ON(vp == NULL) that I put in xfs_iunpin()
>> in this patch. The xfs inode had no link to the bhv_vnode, nor
>> did it have either XFS_IRECLAIM* flag set, and hence it triggered
>> the BUG.
> 
> And again. The xfs_iget_core change is valid - there's still a
> race in xfs_iunpin (how many of them can we find?):
> 
>    xfs_iunpin				xfs_iget_core
>    if(atomic_dec_and_test(pincount))
> 					if (vp == NULL)
> 					   if(IRECLAIMABLE)
> 					       if(pincount)
> 					    	   force+restart
> 					   .....
> 					   clear IRECLAIMABLE
> 
>    	spin_lock(i_flags_lock)
> 	If (IRECLAIMABLE)
> 		BUG_ON(vp == NULL)
> 
> 
> So the solution is this:
> 
> ---
>  fs/xfs/xfs_inode.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-18 11:27:04.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-18 16:45:12.658102093 +1000
> @@ -2738,7 +2738,7 @@ xfs_iunpin(
>  {
>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
>  
> -	if (atomic_dec_and_test(&ip->i_pincount)) {
> +	if (atomic_dec_and_lock(&ip->i_pincount, &ip->i_flags_lock)) {
>  
>  		/*
>  		 * If the inode is currently being reclaimed, the link between
> @@ -2757,7 +2757,6 @@ xfs_iunpin(
>  		 * unpinned.
>  		 */
>  
> -		spin_lock(&ip->i_flags_lock);
>  		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
>  			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
>  			struct inode *inode = NULL;
> 
> I'm running stress tests on this now - it it survives until morning
> I'll send out a new set of patches for testing...
> 
> Cheers,
> 
> Dave.

-- 
+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+
ＮＥＣ コンピュータソフトウェア事業本部
            ＯＳＳ推進センター 技術開発Ｇ

        永野 武則 (Takenori Nagano)

TEL:8-23-57270(MyLine) 042-333-5383(外線)
e-mail:t-nagano@ah.jp.nec.com
+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+=-=+

--------------020703010704010900070501
Content-Type: text/plain;
 name="xfs_idestroy.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="xfs_idestroy.patch"

ZGlmZiAtTmFydSBsaW51eC0yLjYuMTktcmMxL2ZzL3hmcy5vcmlnL3hmc19p
bm9kZS5jIGxpbnV4LTIuNi4xOS1yYzEvZnMveGZzL3hmc19pbm9kZS5jCi0t
LSBsaW51eC0yLjYuMTktcmMxL2ZzL3hmcy5vcmlnL3hmc19pbm9kZS5jCTIw
MDYtMTAtMTkgMDE6NTE6NDMuMDIwMDAwMDAwICswOTAwCisrKyBsaW51eC0y
LjYuMTktcmMxL2ZzL3hmcy94ZnNfaW5vZGUuYwkyMDA2LTEwLTE5IDAxOjUz
OjQ3LjI0ODAwMDAwMCArMDkwMApAQCAtMjcxMyw2ICsyNzEzLDcgQEAKIAkJ
ICAgICAgIFhGU19GT1JDRURfU0hVVERPV04oaXAtPmlfbW91bnQpKTsKIAkJ
eGZzX2lub2RlX2l0ZW1fZGVzdHJveShpcCk7CiAJfQorCXhmc19pdW5waW5f
d2FpdChpcCk7CiAJa21lbV96b25lX2ZyZWUoeGZzX2lub2RlX3pvbmUsIGlw
KTsKIH0KIApAQCAtMjc4NCw3ICsyNzg1LDcgQEAKICAqIGJlIHN1YnNlcXVl
bnRseSBwaW5uZWQgb25jZSBzb21lb25lIGlzIHdhaXRpbmcgZm9yIGl0IHRv
IGJlCiAgKiB1bnBpbm5lZC4KICAqLwotU1RBVElDIHZvaWQKK3ZvaWQKIHhm
c19pdW5waW5fd2FpdCgKIAl4ZnNfaW5vZGVfdAkqaXApCiB7CmRpZmYgLU5h
cnUgbGludXgtMi42LjE5LXJjMS9mcy94ZnMub3JpZy94ZnNfaW5vZGUuaCBs
aW51eC0yLjYuMTktcmMxL2ZzL3hmcy94ZnNfaW5vZGUuaAotLS0gbGludXgt
Mi42LjE5LXJjMS9mcy94ZnMub3JpZy94ZnNfaW5vZGUuaAkyMDA2LTEwLTE5
IDAxOjUxOjQyLjk4MDAwMDAwMCArMDkwMAorKysgbGludXgtMi42LjE5LXJj
MS9mcy94ZnMveGZzX2lub2RlLmgJMjAwNi0xMC0xOSAwMTo1MjoxNy45ODAw
MDAwMDAgKzA5MDAKQEAgLTQ5OCw2ICs0OTgsNyBAQAogdm9pZAkJeGZzX2ly
b290X3JlYWxsb2MoeGZzX2lub2RlX3QgKiwgaW50LCBpbnQpOwogdm9pZAkJ
eGZzX2lwaW4oeGZzX2lub2RlX3QgKik7CiB2b2lkCQl4ZnNfaXVucGluKHhm
c19pbm9kZV90ICopOwordm9pZAkJeGZzX2l1bnBpbl93YWl0KHhmc19pbm9k
ZV90ICopOwogaW50CQl4ZnNfaWV4dGVudHNfY29weSh4ZnNfaW5vZGVfdCAq
LCB4ZnNfYm1idF9yZWNfdCAqLCBpbnQpOwogaW50CQl4ZnNfaWZsdXNoKHhm
c19pbm9kZV90ICosIHVpbnQpOwogdm9pZAkJeGZzX2lmbHVzaF9hbGwoc3Ry
dWN0IHhmc19tb3VudCAqKTsK

--------------020703010704010900070501--
