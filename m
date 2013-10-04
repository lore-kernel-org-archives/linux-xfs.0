Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B75877F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 15:48:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5088EAC007
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 13:48:22 -0700 (PDT)
Received: from mail-oa0-f49.google.com (mail-oa0-f49.google.com
	[209.85.219.49]) by cuda.sgi.com with ESMTP id T0DJmiSsus0NlWAw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Oct 2013 13:48:20 -0700 (PDT)
Received: by mail-oa0-f49.google.com with SMTP id i4so4500644oah.22
	for <xfs@oss.sgi.com>; Fri, 04 Oct 2013 13:48:20 -0700 (PDT)
From: David Zafman <david.zafman@inktank.com>
Subject: RESEND: xattr issue with 3.11 kernel
Date: Fri, 4 Oct 2013 13:48:17 -0700
Message-Id: <ED5C1C84-614E-4EBB-A966-BBCD9CE89373@inktank.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ceph-devel@vger.kernel.org


<<Plain Text>>

This was also seen on a customized 3.10 kernel, but didn't reproduce on the Ubuntu 13.04 packaged 3.8 kernel.

$ cat /etc/issue
Ubuntu 13.04 \n \l
$ uname -a
Linux ubuntu 3.11.0-031100-generic #201309021735 SMP Mon Sep 2 21:36:21 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
$ mount | grep /mnt
/dev/sdb on /mnt type xfs (rw)
$ ./xattr-test.sh /mnt/foo 10240
8
16
32
64
128
256
512
1024
2048
setfattr: /mnt/foo: Structure needs cleaning
failure to remove user.test1557

Oct  4 12:47:44 ubuntu kernel: [ 1824.541889] ffff88003a005000: 46 c4 4f 2f 00 00 06 b5 46 c4 4f a6 00 00 06 b4  F.O/....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542038] ffff88003a005010: 46 c4 4f a7 00 00 06 b3 46 c4 4f a8 00 00 06 b2  F.O.....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542121] ffff88003a005020: 46 c4 4f a9 00 00 06 b1 46 c4 4f aa 00 00 06 b0  F.O.....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542201] ffff88003a005030: 46 c4 4f ab 00 00 06 af 46 c4 4f ac 00 00 06 ae  F.O.....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542286] XFS (sdb): Internal error xfs_da_do_buf(2) at line 2694 of file /home/apw/COD/linux/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0304423
Oct  4 12:47:44 ubuntu kernel: [ 1824.542286]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542421] CPU: 0 PID: 35058 Comm: setfattr Not tainted 3.11.0-031100-generic #201309021735
Oct  4 12:47:44 ubuntu kernel: [ 1824.542422] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
Oct  4 12:47:44 ubuntu kernel: [ 1824.542425]  0000000000000001 ffff8800354ab9f8 ffffffff81720fca 0000000000000007
Oct  4 12:47:44 ubuntu kernel: [ 1824.542428]  ffff88003a27b800 ffff8800354aba18 ffffffffa02cd27f ffffffffa0304423
Oct  4 12:47:44 ubuntu kernel: [ 1824.542430]  0000000000000001 ffff8800354aba58 ffffffffa02cd2ee 0000000000000002
Oct  4 12:47:44 ubuntu kernel: [ 1824.542432] Call Trace:
Oct  4 12:47:44 ubuntu kernel: [ 1824.542447]  [<ffffffff81720fca>] dump_stack+0x46/0x58
Oct  4 12:47:44 ubuntu kernel: [ 1824.542474]  [<ffffffffa02cd27f>] xfs_error_report+0x3f/0x50 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542489]  [<ffffffffa0304423>] ? xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542499]  [<ffffffffa02cd2ee>] xfs_corruption_error+0x5e/0x90 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542511]  [<ffffffffa030438a>] xfs_da_read_buf+0x1ba/0x230 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542522]  [<ffffffffa0304423>] ? xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542539]  [<ffffffffa0332127>] ? xfs_trans_log_buf+0x97/0x100 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542550]  [<ffffffffa0304423>] xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542562]  [<ffffffffa030608c>] xfs_da3_blk_unlink.isra.13+0x16c/0x1e0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542573]  [<ffffffffa030633f>] xfs_da3_join+0x9f/0x240 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542584]  [<ffffffffa02e6872>] xfs_attr_node_removename+0x192/0x300 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542598]  [<ffffffffa0327d5c>] ? xfs_trans_add_item+0x2c/0x70 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542608]  [<ffffffffa02e6b9e>] xfs_attr_remove_int+0x1be/0x260 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542617]  [<ffffffff812ed87c>] ? security_inode_permission+0x1c/0x30
Oct  4 12:47:44 ubuntu kernel: [ 1824.542628]  [<ffffffffa02e8577>] xfs_attr_remove+0xa7/0xb0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542638]  [<ffffffffa02e0c08>] xfs_xattr_set+0x58/0x60 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542645]  [<ffffffff811d5e66>] generic_removexattr+0x46/0x60
Oct  4 12:47:44 ubuntu kernel: [ 1824.542648]  [<ffffffff811d6124>] vfs_removexattr+0xa4/0x140
Oct  4 12:47:44 ubuntu kernel: [ 1824.542651]  [<ffffffff811d6212>] removexattr+0x52/0x80
Oct  4 12:47:44 ubuntu kernel: [ 1824.542658]  [<ffffffff811be016>] ? final_putname+0x26/0x50
Oct  4 12:47:44 ubuntu kernel: [ 1824.542661]  [<ffffffff811be249>] ? putname+0x29/0x40
Oct  4 12:47:44 ubuntu kernel: [ 1824.542665]  [<ffffffff811c27c3>] ? user_path_at_empty+0x63/0xa0
Oct  4 12:47:44 ubuntu kernel: [ 1824.542670]  [<ffffffff811b4903>] ? __sb_start_write+0x53/0x110
Oct  4 12:47:44 ubuntu kernel: [ 1824.542673]  [<ffffffff811d1c68>] ? __mnt_want_write+0x58/0x70
Oct  4 12:47:44 ubuntu kernel: [ 1824.542676]  [<ffffffff811d1cac>] ? mnt_want_write+0x2c/0x50
Oct  4 12:47:44 ubuntu kernel: [ 1824.542679]  [<ffffffff811d738c>] SyS_removexattr+0x7c/0xd0
Oct  4 12:47:44 ubuntu kernel: [ 1824.542684]  [<ffffffff81735cef>] tracesys+0xe1/0xe6
Oct  4 12:47:44 ubuntu kernel: [ 1824.542686] XFS (sdb): Corruption detected. Unmount and run xfs_repair

Oct  4 12:51:21 ubuntu kernel: [ 2041.893539] INFO: task getfattr:35059 blocked for more than 120 seconds.
Oct  4 12:51:21 ubuntu kernel: [ 2041.893650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 12:51:21 ubuntu kernel: [ 2041.893749] getfattr        D 0000000000000000     0 35059   2071 0x00000004
Oct  4 12:51:21 ubuntu kernel: [ 2041.893753]  ffff8800354a9958 0000000000000002 ffffea0000fdc740 ffffffff00000000
Oct  4 12:51:21 ubuntu kernel: [ 2041.893756]  ffff8800354a9fd8 ffff8800354a9fd8 ffff8800354a9fd8 0000000000014580
Oct  4 12:51:21 ubuntu kernel: [ 2041.893758]  ffff88003a2c8000 ffff88003982ddc0 0000000000000001 7fffffffffffffff
Oct  4 12:51:21 ubuntu kernel: [ 2041.893761] Call Trace:
Oct  4 12:51:21 ubuntu kernel: [ 2041.893772]  [<ffffffff8172b279>] schedule+0x29/0x70
Oct  4 12:51:21 ubuntu kernel: [ 2041.893777]  [<ffffffff81728755>] schedule_timeout+0x1e5/0x250
Oct  4 12:51:21 ubuntu kernel: [ 2041.893785]  [<ffffffff8136c76e>] ? radix_tree_lookup_slot+0xe/0x10
Oct  4 12:51:21 ubuntu kernel: [ 2041.893793]  [<ffffffff81151635>] ? prep_new_page+0x145/0x1e0
Oct  4 12:51:21 ubuntu kernel: [ 2041.893822]  [<ffffffffa03186ac>] ? xfs_iext_bno_to_ext+0x8c/0x160 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893826]  [<ffffffff81729d68>] __down_common+0x9d/0xed
Oct  4 12:51:21 ubuntu kernel: [ 2041.893836]  [<ffffffffa02caffd>] ? _xfs_buf_find+0xfd/0x2b0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893839]  [<ffffffff81729e2b>] __down+0x1d/0x1f
Oct  4 12:51:21 ubuntu kernel: [ 2041.893847]  [<ffffffff8108e941>] down+0x41/0x50
Oct  4 12:51:21 ubuntu kernel: [ 2041.893856]  [<ffffffffa02cae34>] xfs_buf_lock+0x44/0x110 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893866]  [<ffffffffa02caffd>] _xfs_buf_find+0xfd/0x2b0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893875]  [<ffffffffa02cb284>] xfs_buf_get_map+0x34/0x1b0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893886]  [<ffffffffa02cc231>] xfs_buf_read_map+0x31/0x130 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893900]  [<ffffffffa0302709>] ? xfs_dabuf_map.isra.4+0x239/0x250 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893917]  [<ffffffffa0331c51>] xfs_trans_read_buf_map+0x271/0x490 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893930]  [<ffffffffa030429f>] xfs_da_read_buf+0xcf/0x230 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893942]  [<ffffffffa0304423>] xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893946]  [<ffffffff8109147a>] ? lg_local_unlock+0x1a/0x20
Oct  4 12:51:21 ubuntu kernel: [ 2041.893950]  [<ffffffff811bd536>] ? complete_walk+0xa6/0x120
Oct  4 12:51:21 ubuntu kernel: [ 2041.893961]  [<ffffffffa02e7f5b>] xfs_attr_node_list+0x6b/0x4a0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893966]  [<ffffffff811bf14d>] ? path_lookupat+0x6d/0x730
Oct  4 12:51:21 ubuntu kernel: [ 2041.893970]  [<ffffffff81729cb6>] ? down_read+0x16/0x2b
Oct  4 12:51:21 ubuntu kernel: [ 2041.893983]  [<ffffffffa03161a4>] ? xfs_ilock+0xf4/0x120 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893995]  [<ffffffffa02e8645>] xfs_attr_list_int+0xc5/0xe0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.894007]  [<ffffffffa02e0e46>] xfs_vn_listxattr+0x96/0x170 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.894019]  [<ffffffffa02e0b70>] ? xfs_change_file_space+0x370/0x370 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.894024]  [<ffffffff811d654d>] vfs_listxattr+0x4d/0x80
Oct  4 12:51:21 ubuntu kernel: [ 2041.894027]  [<ffffffff811d65e9>] listxattr+0x69/0x130
Oct  4 12:51:21 ubuntu kernel: [ 2041.894030]  [<ffffffff811d718e>] SyS_listxattr+0x4e/0x90
Oct  4 12:51:21 ubuntu kernel: [ 2041.894034]  [<ffffffff81735cef>] tracesys+0xe1/0xe6

-------------------------------------------- Test Script ----------------------------------------
#! /bin/sh

#getfattr format
#
# # file: foo
# user.test="test"

if [ $# != "2" ];
then
  echo usage: $0 path count
  exit 1
fi

FILENAME=$1
COUNT=$2

rmdir $FILENAME > /dev/null 2>&1

datalen=65536
echo "datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata" > tmp.$$
while test $datalen != 0
do
  dd if=tmp.$$ of=src.$$ bs=512 count=1 conv=notrunc oflag=append 2> /dev/null
  datalen=`expr $datalen - 512`
done
rm tmp.$$

for len in 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
do
  mkdir $FILENAME

  echo $len

  count=0
  while test $count != $COUNT
  do
    entry=user.test`expr $count + 1`
    echo "# file: $FILENAME" > data.$$
    echo -n "$entry" >> data.$$
    echo -n '="' >> data.$$
    dd if=src.$$ of=data.$$ bs=$len count=1 conv=notrunc oflag=append 2> /dev/null
    echo '"' >> data.$$
    #cat data.$$
    #read a
    setfattr --restore=data.$$
    if [ $? != "0" ];
    then
        echo failure to set $entry
        break
    fi
    count=`expr $count + 1`
    #getfattr --dump $FILENAME
  done
  rm data.$$
  rmcount=0
  while test $rmcount != $count
  do
    entry=user.test`expr $rmcount + 1`
    setfattr --remove=$entry $FILENAME
    if [ $? != "0" ];
    then
      echo failure to remove $entry
      break
    fi
    rmcount=`expr $rmcount + 1`
  done
  getfattr --dump $FILENAME
  rmdir $FILENAME
done
rm src.$$

exit 0

----------------------------------------------------------------------------------------

David Zafman
Senior Developer
http://www.inktank.com




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
