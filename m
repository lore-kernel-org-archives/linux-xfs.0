Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8334H0t123792 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 22:04:17 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id EeXeR93dJS5UfI8j
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Sep 2012 20:05:12 -0700 (PDT)
Received: by pbbro2 with SMTP id ro2so8989606pbb.26
	for <xfs@oss.sgi.com>; Sun, 02 Sep 2012 20:05:11 -0700 (PDT)
Date: Mon, 3 Sep 2012 08:35:06 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: XFS regression: Oops in xfs_buf_do_callbacks on xfstest 137
Message-ID: <20120903030506.GA48608@Archie.local>
References: <501ABC84.6030708@sandeen.net>
	<20120817180254.GA15382@infradead.org>
	<502E8A4F.9050105@sandeen.net> <20120903004521.GA61118@Archie>
MIME-Version: 1.0
In-Reply-To: <20120903004521.GA61118@Archie>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5548477250321761764=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


--===============5548477250321761764==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Mon, Sep 03, 2012 at 06:15:21AM +0530, Raghavendra D Prabhu <raghu.pra=
bhu13@gmail.com> wrote:
>Hi,
>
>
>* On Fri, Aug 17, 2012 at 01:15:43PM -0500, Eric Sandeen <sandeen@sandeen.=
net> wrote:
>>On 8/17/12 1:02 PM, Christoph Hellwig wrote:
>>>I'd be this is my new code added to xfs_buf_item_unpin, but I don't
>>>quite understand why.  It's been a long time since I wrote that code,
>>>but I had to add that code to make sure we clear all buffers during
>>>a forced shutdown.  Can you test if things go away if you just remove it
>>>(even if causes other hangs?)
>>
>>It does go away AFAIK, since the bisect found it.
>>
>>Sadly it's been on the back burner for me, under other deadline pressure.
>>
>>-Eric
>>
>>_______________________________________________
>>xfs mailing list
>>xfs@oss.sgi.com
>>http://oss.sgi.com/mailman/listinfo/xfs
>
>I hit the same bug on xfstest 137 while testing and it is indeed=20
>POISON_FREE.
>
>Here are the intermediate backtraces:  http://sprunge.us/HZeD
>
>I am also attaching the full backtrace.
>
>
>git head:
>
>commit b686d1f79acb65c6a34473c15fcfa2ee54aed8e2
> Author: Jeff Liu <jeff.liu@oracle.com>
> Date:   Tue Aug 21 17:12:18 2012 +0800
>

With DEBUG_PAGEALLOC enabled, I got following:

[  182.925026]  [<ffffffff815813ce>] ? xfs_buf_iodone_work+0x43/0xb7
[  182.925026]  [<ffffffff8166c7b5>] xfs_buf_iodone_callbacks+0x4d2/0x5aa
[  182.925026]  [<ffffffff8166d041>] ? xfs_buf_item_unpin+0x7b4/0x812
[  182.925026]  [<ffffffff815813ce>] xfs_buf_iodone_work+0x43/0xb7
[  182.925026]  [<ffffffff81581ccc>] xfs_buf_ioend+0x29a/0x2fc
[  182.925026]  [<ffffffff8166d041>] xfs_buf_item_unpin+0x7b4/0x812
[  182.925026]  [<ffffffff8165bfe4>] xfs_trans_committed_bulk+0x223/0x6d1
[  182.925026]  [<ffffffff81317583>] ? __slab_free+0xa46/0xc2f
[  182.925026]  [<ffffffff81665edc>] ? xlog_write+0x18b/0x95c
[  182.925026]  [<ffffffff8116f30b>] ? debug_check_no_locks_freed+0x121/0x1=
7b
[  182.925026]  [<ffffffff81318ab0>] ? kmem_cache_free+0x338/0x491
[  182.925026]  [<ffffffff81661dcf>] ? xfs_log_ticket_put+0xaf/0xbc
[  182.925026]  [<ffffffff81667fe7>] xlog_cil_committed+0x3b/0x1fa
[  182.925026]  [<ffffffff816691e1>] xlog_cil_push+0x6ca/0x6f6
[  182.925026]  [<ffffffff81170c84>] ? __lock_release+0x64/0xb6
[  182.925026]  [<ffffffff81669389>] xlog_cil_push_foreground+0x17c/0x1fa
[  182.925026]  [<ffffffff816697d1>] xlog_cil_force_lsn+0x90/0x27e
[  182.925026]  [<ffffffff813a4a42>] ? sync_inodes_sb+0x23e/0x26c
[  182.925026]  [<ffffffff81664c3c>] _xfs_log_force+0x67/0x620
[  182.925026]  [<ffffffff81db7f97>] ? wait_for_common+0x231/0x3ac
[  182.925026]  [<ffffffff81665359>] xfs_log_force+0x164/0x1c2
[  182.925026]  [<ffffffff815ac8cc>] xfs_quiesce_data+0x21/0x9f
[  182.925026]  [<ffffffff815a6780>] xfs_fs_sync_fs+0x5a/0xe0
[  182.925026]  [<ffffffff813af269>] __sync_filesystem+0x9e/0xc2
[  182.925026]  [<ffffffff813af357>] sync_filesystem+0xca/0x12d
[  182.925026]  [<ffffffff8134c95f>] generic_shutdown_super+0x61/0x203
[  182.925026]  [<ffffffff8134cb42>] kill_block_super+0x41/0x1a6
[  182.925026]  [<ffffffff8134dbf4>] deactivate_locked_super+0x9b/0x104
[  182.925026]  [<ffffffff8134f0a7>] deactivate_super+0x147/0x187
[  182.925026]  [<ffffffff8138f1d4>] mntput_no_expire+0x308/0x32a
[  182.925026]  [<ffffffff81391bc5>] sys_umount+0x1a6/0x1e4
[  182.925026]  [<ffffffff81dcb3e9>] system_call_fastpath+0x16/0x1b

Full here -- http://sprunge.us/CPKW=20

One more thing, in xfs_buf_do_callbacks,


	while ((lip =3D bp->b_fspriv) !=3D NULL) {
		bp->b_fspriv =3D lip->li_bio_list;
		ASSERT(lip->li_cb !=3D NULL);

     In the loop before the crash, lip->li_bio_list is NULL which=20
     explains the use-after-free.


>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs





Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQRB5iAAoJEKYW3KHXK+l3/3sIAK7DAHaVxjpjkf38TQPyIKmK
0dho5D3gVfTd3WuDDBHzjI2onDYWiCT/ADGajGXlFGm9vjlrkurc09dusE5EeUXT
AIJGWIc8rGoikW+WOnbdFlO6ux57vLXci0LGTqLrS6+f72T7ai/qIyS6MHxxu/+3
B1bNFj/QK5tWV/NqNOctvp2+axuQUu/IVd++gT2b1qyGYfx7H9qutINF6psOYQNa
fNkVQc2/yYs40yGCIY7RjDlxkVuFKRgj8sM3CQtg23TRlBBE2HgtIkTj7k1u6Nfw
MLFgvCBoDtgT6G/GQBhgMf08JtdEzwQHplM+oUbCtm6rZQMeJLnrFVqh/M2x7tI=
=DHsg
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--


--===============5548477250321761764==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5548477250321761764==--
