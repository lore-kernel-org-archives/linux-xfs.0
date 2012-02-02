Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12AwrWj045543 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 04:58:54 -0600
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id gq1vfbQSMRmXQCAM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 02:58:52 -0800 (PST)
From: <Kiran.Chandapu@emc.com>
Date: Thu, 2 Feb 2012 05:58:34 -0500
Subject: RE: xfs_repair takes long time
Message-ID: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A21@MX03A.corp.emc.com>
References: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02@MX03A.corp.emc.com>
	<20120202091715.GC31203@infradead.org>
	<D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A10@MX03A.corp.emc.com>
	<20120202104825.GA7670@infradead.org>
In-Reply-To: <20120202104825.GA7670@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org
Cc: xfs@oss.sgi.com

Actually I did not lose LV metadata but I had lost PV metadata after reactivating raid5 and i had recovered and VG restore did restore both volume group and lv information. I have cross checked the uuid with old volume group backup and it is same. 

I was going through the forum and somewhere I found that we need to check whether we have xfs file system information exist or overwritten with some information on /dev/md1 and I saw that I have correct information on /dev/md0 but not /dev/md1 which has my data on it. 

(/dev/md0 info)

root@DDATA:/var/log# dd if=/dev/mapper/282b4cad_vg-vol1  bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x   
000000 4658 4253 0000 0010 0000 0000 2700 00fc
000010 0000 0000 0000 0000 0000 0000 0000 0000
000020 5d45 f521 4c26 5b4c 4786 f0fd 077d bd2f
000030 0000 0000 2000 0400 0000 0000 0000 8000
000040 0000 0000 0000 8100 0000 0000 0000 8200
000050 0000 0100 0900 00ff 0000 0400 0000 0000
000060 0000 000a a4b4 0002 0001 1000 0000 0000
000070 0000 0000 0000 0000 090c 0408 0014 1900
000080 0000 0000 0000 c00a 0000 0000 0000 5f01
000090 0000 0000 2200 3586 0000 0000 0000 0000
0000a0 0000 0000 0000 0000 0000 0000 0000 0000
0000b0 0000 0000 0000 0200 0000 0000 0000 0000
0000c0 0000 0000 0000 0100 0000 0800 0000 0800
0000d0 0000 0000 0000 0000 0000 0000 0000 0000
*
000200
-----------------------------------------------------------------------------------------------------------------------------

(/dev/md1 info)

root@DDATA:/var/log# dd if=/dev/mapper/3f983026_vg-lv355ff6e0  bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
000000 6686 5693 f243 67de 4010 9e19 ce94 f5cf
000010 2bd7 36ab c2c3 1b4b db68 3ef2 67d3 78a3
000020 13c7 f475 655a 48c6 0d5f b088 971b 4c95
000030 bcd9 a105 ba22 7303 630d ac0e fbe8 10fb
000040 d798 578b 9f30 0f9a 0b3f ffbf a58c ecc1
000050 d7d5 0c34 1c3c 0876 ff35 db75 672a b966
000060 0b06 0626 e138 ed3d af67 680a 24ed 07e1
000070 5686 c756 6bbf 3d97 5fbe 44eb a2ef 0877
000080 2876 9ef0 0707 b6e7 49bc 0994 e64e 7bd5
000090 0571 46a8 aaab 08c3 ab52 7449 779a 6569
0000a0 df95 e007 fc09 a2b3 78af 6a71 75d2 d252
0000b0 ca55 0e19 be8e 73a0 ea93 6162 3c5a c71a
0000c0 a17c 0c10 60a1 7a80 4c0e ae73 5b82 9d96
0000d0 6276 3a41 befe 9639 2ec0 a9c1 6a2d adfe
0000e0 c0a4 04eb a869 4e03 fdd1 5a7f 4e94 ad07
0000f0 ff90 283b 4385 bce6 da93 6d5a 72d0 6ff2
000100 0b73 f7ed a9d5 9ffe 82b2 5c4b b765 e3bb
000110 e30f 9aac a413 aa60 8c63 254b de03 c528
000120 5c28 0342 6bac fcdc 94ee e0a6 3e66 0185
000130 7731 d95f b32b 3d60 60f7 55c2 00c9 92e4
000140 3f0a b251 41c4 ec4d 449e 2a53 7537 fba6
000150 3d0a 0006 01d4 64aa 44e9 faa1 47ce a170
000160 5584 c155 08b6 2929 d260 e9ea 2211 3791
000170 b6ad 0620 cc20 8ffa 8b72 0b9f 1834 3cb3
000180 d754 f410 2d03 b5b3 ff8c e8f0 1b9b e806
000190 26f2 927e 3376 a638 bcb0 f928 de58 8c62
0001a0 6004 77ac 6661 562f dc0e d516 4979 8929
0001b0 7a6b 7b99 c591 f4c3 f31a 54e7 2c9f 81cb
0001c0 37e8 13ab 7988 b206 c2f3 7bc5 4c81 9982
0001d0 96bc b19f 7229 a9a2 002c 08a2 ce17 2ef4
0001e0 f467 81fc df12 6146 b13a eeff ef67 7085
0001f0 3926 2b40 0d27 fd5e eec2 cba1 b558 ebf6
000200


Thanks
-Kiran

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, February 02, 2012 4:18 PM
To: Chandapu, Kiran
Cc: hch@infradead.org; xfs@oss.sgi.com
Subject: Re: xfs_repair takes long time

On Thu, Feb 02, 2012 at 04:29:00AM -0500, Kiran.Chandapu@emc.com wrote:
> Hello Christoph,
> 
> Thanks, I would try to upgrade it. Could you please tell me whether we can recover the data, actually we have all our data about 12 TB resides on that volume which has the issue. 

Given your description of missing LV metadata I suspect that you actually have lost part if not all of the filesystem.  Running xfs_repair -nv will give you more information about, but if you have indeed destroyed the lvm block mapping it won't be able to do much.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
