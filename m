Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58FA97F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 15:35:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04744AC007
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 13:35:39 -0700 (PDT)
Received: from mail-oa0-f48.google.com (mail-oa0-f48.google.com
	[209.85.219.48]) by cuda.sgi.com with ESMTP id T1VJK7BxllAqpjR2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Oct 2013 13:35:37 -0700 (PDT)
Received: by mail-oa0-f48.google.com with SMTP id m6so4472302oag.7
	for <xfs@oss.sgi.com>; Fri, 04 Oct 2013 13:35:37 -0700 (PDT)
From: David Zafman <david.zafman@inktank.com>
Subject: xattr issue with 3.11 kernel
Date: Fri, 4 Oct 2013 13:35:29 -0700
Message-Id: <EE30DCE9-E14C-44D3-AF6C-A3592504A69D@inktank.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3277510080828472255=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: ceph-devel@vger.kernel.org


--===============3277510080828472255==
Content-Type: multipart/alternative; boundary="Apple-Mail=_5CCEB2A4-B0FD-4058-B53F-B11D32757AE9"


--Apple-Mail=_5CCEB2A4-B0FD-4058-B53F-B11D32757AE9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


This was also seen on a customized 3.10 kernel, but didn't reproduce on =
the Ubuntu 13.04 packaged 3.8 kernel.

$ cat /etc/issue
Ubuntu 13.04 \n \l
$ uname -a
Linux ubuntu 3.11.0-031100-generic #201309021735 SMP Mon Sep 2 21:36:21 =
UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
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

Oct  4 12:47:44 ubuntu kernel: [ 1824.541889] ffff88003a005000: 46 c4 4f =
2f 00 00 06 b5 46 c4 4f a6 00 00 06 b4  F.O/....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542038] ffff88003a005010: 46 c4 4f =
a7 00 00 06 b3 46 c4 4f a8 00 00 06 b2  F.O.....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542121] ffff88003a005020: 46 c4 4f =
a9 00 00 06 b1 46 c4 4f aa 00 00 06 b0  F.O.....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542201] ffff88003a005030: 46 c4 4f =
ab 00 00 06 af 46 c4 4f ac 00 00 06 ae  F.O.....F.O.....
Oct  4 12:47:44 ubuntu kernel: [ 1824.542286] XFS (sdb): Internal error =
xfs_da_do_buf(2) at line 2694 of file =
/home/apw/COD/linux/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0304423
Oct  4 12:47:44 ubuntu kernel: [ 1824.542286]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542421] CPU: 0 PID: 35058 Comm: =
setfattr Not tainted 3.11.0-031100-generic #201309021735
Oct  4 12:47:44 ubuntu kernel: [ 1824.542422] Hardware name: VMware, =
Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 =
07/31/2013
Oct  4 12:47:44 ubuntu kernel: [ 1824.542425]  0000000000000001 =
ffff8800354ab9f8 ffffffff81720fca 0000000000000007
Oct  4 12:47:44 ubuntu kernel: [ 1824.542428]  ffff88003a27b800 =
ffff8800354aba18 ffffffffa02cd27f ffffffffa0304423
Oct  4 12:47:44 ubuntu kernel: [ 1824.542430]  0000000000000001 =
ffff8800354aba58 ffffffffa02cd2ee 0000000000000002
Oct  4 12:47:44 ubuntu kernel: [ 1824.542432] Call Trace:
Oct  4 12:47:44 ubuntu kernel: [ 1824.542447]  [<ffffffff81720fca>] =
dump_stack+0x46/0x58
Oct  4 12:47:44 ubuntu kernel: [ 1824.542474]  [<ffffffffa02cd27f>] =
xfs_error_report+0x3f/0x50 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542489]  [<ffffffffa0304423>] ? =
xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542499]  [<ffffffffa02cd2ee>] =
xfs_corruption_error+0x5e/0x90 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542511]  [<ffffffffa030438a>] =
xfs_da_read_buf+0x1ba/0x230 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542522]  [<ffffffffa0304423>] ? =
xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542539]  [<ffffffffa0332127>] ? =
xfs_trans_log_buf+0x97/0x100 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542550]  [<ffffffffa0304423>] =
xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542562]  [<ffffffffa030608c>] =
xfs_da3_blk_unlink.isra.13+0x16c/0x1e0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542573]  [<ffffffffa030633f>] =
xfs_da3_join+0x9f/0x240 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542584]  [<ffffffffa02e6872>] =
xfs_attr_node_removename+0x192/0x300 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542598]  [<ffffffffa0327d5c>] ? =
xfs_trans_add_item+0x2c/0x70 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542608]  [<ffffffffa02e6b9e>] =
xfs_attr_remove_int+0x1be/0x260 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542617]  [<ffffffff812ed87c>] ? =
security_inode_permission+0x1c/0x30
Oct  4 12:47:44 ubuntu kernel: [ 1824.542628]  [<ffffffffa02e8577>] =
xfs_attr_remove+0xa7/0xb0 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542638]  [<ffffffffa02e0c08>] =
xfs_xattr_set+0x58/0x60 [xfs]
Oct  4 12:47:44 ubuntu kernel: [ 1824.542645]  [<ffffffff811d5e66>] =
generic_removexattr+0x46/0x60
Oct  4 12:47:44 ubuntu kernel: [ 1824.542648]  [<ffffffff811d6124>] =
vfs_removexattr+0xa4/0x140
Oct  4 12:47:44 ubuntu kernel: [ 1824.542651]  [<ffffffff811d6212>] =
removexattr+0x52/0x80
Oct  4 12:47:44 ubuntu kernel: [ 1824.542658]  [<ffffffff811be016>] ? =
final_putname+0x26/0x50
Oct  4 12:47:44 ubuntu kernel: [ 1824.542661]  [<ffffffff811be249>] ? =
putname+0x29/0x40
Oct  4 12:47:44 ubuntu kernel: [ 1824.542665]  [<ffffffff811c27c3>] ? =
user_path_at_empty+0x63/0xa0
Oct  4 12:47:44 ubuntu kernel: [ 1824.542670]  [<ffffffff811b4903>] ? =
__sb_start_write+0x53/0x110
Oct  4 12:47:44 ubuntu kernel: [ 1824.542673]  [<ffffffff811d1c68>] ? =
__mnt_want_write+0x58/0x70
Oct  4 12:47:44 ubuntu kernel: [ 1824.542676]  [<ffffffff811d1cac>] ? =
mnt_want_write+0x2c/0x50
Oct  4 12:47:44 ubuntu kernel: [ 1824.542679]  [<ffffffff811d738c>] =
SyS_removexattr+0x7c/0xd0
Oct  4 12:47:44 ubuntu kernel: [ 1824.542684]  [<ffffffff81735cef>] =
tracesys+0xe1/0xe6
Oct  4 12:47:44 ubuntu kernel: [ 1824.542686] XFS (sdb): Corruption =
detected. Unmount and run xfs_repair

Oct  4 12:51:21 ubuntu kernel: [ 2041.893539] INFO: task getfattr:35059 =
blocked for more than 120 seconds.
Oct  4 12:51:21 ubuntu kernel: [ 2041.893650] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 12:51:21 ubuntu kernel: [ 2041.893749] getfattr        D =
0000000000000000     0 35059   2071 0x00000004
Oct  4 12:51:21 ubuntu kernel: [ 2041.893753]  ffff8800354a9958 =
0000000000000002 ffffea0000fdc740 ffffffff00000000
Oct  4 12:51:21 ubuntu kernel: [ 2041.893756]  ffff8800354a9fd8 =
ffff8800354a9fd8 ffff8800354a9fd8 0000000000014580
Oct  4 12:51:21 ubuntu kernel: [ 2041.893758]  ffff88003a2c8000 =
ffff88003982ddc0 0000000000000001 7fffffffffffffff
Oct  4 12:51:21 ubuntu kernel: [ 2041.893761] Call Trace:
Oct  4 12:51:21 ubuntu kernel: [ 2041.893772]  [<ffffffff8172b279>] =
schedule+0x29/0x70
Oct  4 12:51:21 ubuntu kernel: [ 2041.893777]  [<ffffffff81728755>] =
schedule_timeout+0x1e5/0x250
Oct  4 12:51:21 ubuntu kernel: [ 2041.893785]  [<ffffffff8136c76e>] ? =
radix_tree_lookup_slot+0xe/0x10
Oct  4 12:51:21 ubuntu kernel: [ 2041.893793]  [<ffffffff81151635>] ? =
prep_new_page+0x145/0x1e0
Oct  4 12:51:21 ubuntu kernel: [ 2041.893822]  [<ffffffffa03186ac>] ? =
xfs_iext_bno_to_ext+0x8c/0x160 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893826]  [<ffffffff81729d68>] =
__down_common+0x9d/0xed
Oct  4 12:51:21 ubuntu kernel: [ 2041.893836]  [<ffffffffa02caffd>] ? =
_xfs_buf_find+0xfd/0x2b0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893839]  [<ffffffff81729e2b>] =
__down+0x1d/0x1f
Oct  4 12:51:21 ubuntu kernel: [ 2041.893847]  [<ffffffff8108e941>] =
down+0x41/0x50
Oct  4 12:51:21 ubuntu kernel: [ 2041.893856]  [<ffffffffa02cae34>] =
xfs_buf_lock+0x44/0x110 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893866]  [<ffffffffa02caffd>] =
_xfs_buf_find+0xfd/0x2b0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893875]  [<ffffffffa02cb284>] =
xfs_buf_get_map+0x34/0x1b0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893886]  [<ffffffffa02cc231>] =
xfs_buf_read_map+0x31/0x130 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893900]  [<ffffffffa0302709>] ? =
xfs_dabuf_map.isra.4+0x239/0x250 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893917]  [<ffffffffa0331c51>] =
xfs_trans_read_buf_map+0x271/0x490 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893930]  [<ffffffffa030429f>] =
xfs_da_read_buf+0xcf/0x230 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893942]  [<ffffffffa0304423>] =
xfs_da3_node_read+0x23/0xd0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893946]  [<ffffffff8109147a>] ? =
lg_local_unlock+0x1a/0x20
Oct  4 12:51:21 ubuntu kernel: [ 2041.893950]  [<ffffffff811bd536>] ? =
complete_walk+0xa6/0x120
Oct  4 12:51:21 ubuntu kernel: [ 2041.893961]  [<ffffffffa02e7f5b>] =
xfs_attr_node_list+0x6b/0x4a0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893966]  [<ffffffff811bf14d>] ? =
path_lookupat+0x6d/0x730
Oct  4 12:51:21 ubuntu kernel: [ 2041.893970]  [<ffffffff81729cb6>] ? =
down_read+0x16/0x2b
Oct  4 12:51:21 ubuntu kernel: [ 2041.893983]  [<ffffffffa03161a4>] ? =
xfs_ilock+0xf4/0x120 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.893995]  [<ffffffffa02e8645>] =
xfs_attr_list_int+0xc5/0xe0 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.894007]  [<ffffffffa02e0e46>] =
xfs_vn_listxattr+0x96/0x170 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.894019]  [<ffffffffa02e0b70>] ? =
xfs_change_file_space+0x370/0x370 [xfs]
Oct  4 12:51:21 ubuntu kernel: [ 2041.894024]  [<ffffffff811d654d>] =
vfs_listxattr+0x4d/0x80
Oct  4 12:51:21 ubuntu kernel: [ 2041.894027]  [<ffffffff811d65e9>] =
listxattr+0x69/0x130
Oct  4 12:51:21 ubuntu kernel: [ 2041.894030]  [<ffffffff811d718e>] =
SyS_listxattr+0x4e/0x90
Oct  4 12:51:21 ubuntu kernel: [ 2041.894034]  [<ffffffff81735cef>] =
tracesys+0xe1/0xe6

-------------------------------------------- Test Script =
----------------------------------------
#! /bin/sh

#getfattr format
#
# # file: foo
# user.test=3D"test"

if [ $# !=3D "2" ];
then
  echo usage: $0 path count
  exit 1
fi

FILENAME=3D$1
COUNT=3D$2

rmdir $FILENAME > /dev/null 2>&1

datalen=3D65536
echo =
"datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatad=
atadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadat=
adatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatad=
atadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadat=
adatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatad=
atadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadat=
adatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata" > =
tmp.$$
while test $datalen !=3D 0
do
  dd if=3Dtmp.$$ of=3Dsrc.$$ bs=3D512 count=3D1 conv=3Dnotrunc =
oflag=3Dappend 2> /dev/null
  datalen=3D`expr $datalen - 512`
done
rm tmp.$$

for len in 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
do
  mkdir $FILENAME

  echo $len

  count=3D0
  while test $count !=3D $COUNT
  do
    entry=3Duser.test`expr $count + 1`
    echo "# file: $FILENAME" > data.$$
    echo -n "$entry" >> data.$$
    echo -n '=3D"' >> data.$$
    dd if=3Dsrc.$$ of=3Ddata.$$ bs=3D$len count=3D1 conv=3Dnotrunc =
oflag=3Dappend 2> /dev/null
    echo '"' >> data.$$
    #cat data.$$
    #read a
    setfattr --restore=3Ddata.$$
    if [ $? !=3D "0" ];
    then
        echo failure to set $entry
        break
    fi
    count=3D`expr $count + 1`
    #getfattr --dump $FILENAME
  done
  rm data.$$
  rmcount=3D0
  while test $rmcount !=3D $count
  do
    entry=3Duser.test`expr $rmcount + 1`
    setfattr --remove=3D$entry $FILENAME
    if [ $? !=3D "0" ];
    then
      echo failure to remove $entry
      break
    fi
    rmcount=3D`expr $rmcount + 1`
  done
  getfattr --dump $FILENAME
  rmdir $FILENAME
done
rm src.$$

exit 0

=
--------------------------------------------------------------------------=
--------------

David Zafman
Senior Developer
http://www.inktank.com





--Apple-Mail=_5CCEB2A4-B0FD-4058-B53F-B11D32757AE9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"><meta http-equiv=3D"Content-Type" content=3D"text/html=
 charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div><div><br></div><div>This was also seen on a customized 3.10 =
kernel, but didn't reproduce on the Ubuntu 13.04 packaged 3.8 =
kernel.</div><div><br></div><div>$ cat /etc/issue</div><div>Ubuntu 13.04 =
\n \l</div></div><div><div>$ uname -a</div><div>Linux ubuntu =
3.11.0-031100-generic #201309021735 SMP Mon Sep 2 21:36:21 UTC 2013 =
x86_64 x86_64 x86_64 GNU/Linux</div></div><div>$ mount | grep =
/mnt</div><div>/dev/sdb on /mnt type xfs (rw)</div><div><div>$ =
./xattr-test.sh /mnt/foo =
10240</div><div>8</div><div>16</div><div>32</div><div>64</div><div>128</di=
v><div>256</div><div>512</div><div>1024</div><div>2048</div><div>setfattr:=
 /mnt/foo: Structure needs cleaning</div><div>failure to remove =
user.test1557</div></div><div><br></div><div><div>Oct &nbsp;4 12:47:44 =
ubuntu kernel: [ 1824.541889] ffff88003a005000: 46 c4 4f 2f 00 00 06 b5 =
46 c4 4f a6 00 00 06 b4 &nbsp;F.O/....F.O.....</div><div>Oct &nbsp;4 =
12:47:44 ubuntu kernel: [ 1824.542038] ffff88003a005010: 46 c4 4f a7 00 =
00 06 b3 46 c4 4f a8 00 00 06 b2 &nbsp;F.O.....F.O.....</div><div>Oct =
&nbsp;4 12:47:44 ubuntu kernel: [ 1824.542121] ffff88003a005020: 46 c4 =
4f a9 00 00 06 b1 46 c4 4f aa 00 00 06 b0 =
&nbsp;F.O.....F.O.....</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542201] ffff88003a005030: 46 c4 4f ab 00 00 06 af 46 c4 4f ac 00 00 =
06 ae &nbsp;F.O.....F.O.....</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542286] XFS (sdb): Internal error xfs_da_do_buf(2) at =
line 2694 of file /home/apw/COD/linux/fs/xfs/xfs_da_btree.c. =
&nbsp;Caller 0xffffffffa0304423</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542286]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542421] CPU: 0 PID: 35058 Comm: setfattr Not tainted =
3.11.0-031100-generic #201309021735</div><div>Oct &nbsp;4 12:47:44 =
ubuntu kernel: [ 1824.542422] Hardware name: VMware, Inc. VMware Virtual =
Platform/440BX Desktop Reference Platform, BIOS 6.00 =
07/31/2013</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542425] =
&nbsp;0000000000000001 ffff8800354ab9f8 ffffffff81720fca =
0000000000000007</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542428] &nbsp;ffff88003a27b800 ffff8800354aba18 ffffffffa02cd27f =
ffffffffa0304423</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542430] &nbsp;0000000000000001 ffff8800354aba58 ffffffffa02cd2ee =
0000000000000002</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542432] Call Trace:</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542447] &nbsp;[&lt;ffffffff81720fca&gt;] =
dump_stack+0x46/0x58</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542474] &nbsp;[&lt;ffffffffa02cd27f&gt;] xfs_error_report+0x3f/0x50 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542489] =
&nbsp;[&lt;ffffffffa0304423&gt;] ? xfs_da3_node_read+0x23/0xd0 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542499] =
&nbsp;[&lt;ffffffffa02cd2ee&gt;] xfs_corruption_error+0x5e/0x90 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542511] =
&nbsp;[&lt;ffffffffa030438a&gt;] xfs_da_read_buf+0x1ba/0x230 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542522] =
&nbsp;[&lt;ffffffffa0304423&gt;] ? xfs_da3_node_read+0x23/0xd0 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542539] =
&nbsp;[&lt;ffffffffa0332127&gt;] ? xfs_trans_log_buf+0x97/0x100 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542550] =
&nbsp;[&lt;ffffffffa0304423&gt;] xfs_da3_node_read+0x23/0xd0 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542562] =
&nbsp;[&lt;ffffffffa030608c&gt;] xfs_da3_blk_unlink.isra.13+0x16c/0x1e0 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542573] =
&nbsp;[&lt;ffffffffa030633f&gt;] xfs_da3_join+0x9f/0x240 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542584] =
&nbsp;[&lt;ffffffffa02e6872&gt;] xfs_attr_node_removename+0x192/0x300 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542598] =
&nbsp;[&lt;ffffffffa0327d5c&gt;] ? xfs_trans_add_item+0x2c/0x70 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542608] =
&nbsp;[&lt;ffffffffa02e6b9e&gt;] xfs_attr_remove_int+0x1be/0x260 =
[xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ 1824.542617] =
&nbsp;[&lt;ffffffff812ed87c&gt;] ? =
security_inode_permission+0x1c/0x30</div><div>Oct &nbsp;4 12:47:44 =
ubuntu kernel: [ 1824.542628] &nbsp;[&lt;ffffffffa02e8577&gt;] =
xfs_attr_remove+0xa7/0xb0 [xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542638] &nbsp;[&lt;ffffffffa02e0c08&gt;] =
xfs_xattr_set+0x58/0x60 [xfs]</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542645] &nbsp;[&lt;ffffffff811d5e66&gt;] =
generic_removexattr+0x46/0x60</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542648] &nbsp;[&lt;ffffffff811d6124&gt;] =
vfs_removexattr+0xa4/0x140</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: =
[ 1824.542651] &nbsp;[&lt;ffffffff811d6212&gt;] =
removexattr+0x52/0x80</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542658] &nbsp;[&lt;ffffffff811be016&gt;] ? =
final_putname+0x26/0x50</div></div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542661] &nbsp;[&lt;ffffffff811be249&gt;] ? =
putname+0x29/0x40</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542665] &nbsp;[&lt;ffffffff811c27c3&gt;] ? =
user_path_at_empty+0x63/0xa0</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542670] &nbsp;[&lt;ffffffff811b4903&gt;] ? =
__sb_start_write+0x53/0x110</div><div>Oct &nbsp;4 12:47:44 ubuntu =
kernel: [ 1824.542673] &nbsp;[&lt;ffffffff811d1c68&gt;] ? =
__mnt_want_write+0x58/0x70</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: =
[ 1824.542676] &nbsp;[&lt;ffffffff811d1cac&gt;] ? =
mnt_want_write+0x2c/0x50</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542679] &nbsp;[&lt;ffffffff811d738c&gt;] =
SyS_removexattr+0x7c/0xd0</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: =
[ 1824.542684] &nbsp;[&lt;ffffffff81735cef&gt;] =
tracesys+0xe1/0xe6</div><div>Oct &nbsp;4 12:47:44 ubuntu kernel: [ =
1824.542686] XFS (sdb): Corruption detected. Unmount and run =
xfs_repair</div><div><br></div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: =
[ 2041.893539] INFO: task getfattr:35059 blocked for more than 120 =
seconds.</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893650] =
"echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893749] =
getfattr &nbsp; &nbsp; &nbsp; &nbsp;D 0000000000000000 &nbsp; &nbsp; 0 =
35059 &nbsp; 2071 0x00000004</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893753] &nbsp;ffff8800354a9958 0000000000000002 =
ffffea0000fdc740 ffffffff00000000</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893756] &nbsp;ffff8800354a9fd8 ffff8800354a9fd8 =
ffff8800354a9fd8 0000000000014580</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893758] &nbsp;ffff88003a2c8000 ffff88003982ddc0 =
0000000000000001 7fffffffffffffff</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893761] Call Trace:</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893772] &nbsp;[&lt;ffffffff8172b279&gt;] =
schedule+0x29/0x70</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ =
2041.893777] &nbsp;[&lt;ffffffff81728755&gt;] =
schedule_timeout+0x1e5/0x250</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893785] &nbsp;[&lt;ffffffff8136c76e&gt;] ? =
radix_tree_lookup_slot+0xe/0x10</div><div>Oct &nbsp;4 12:51:21 ubuntu =
kernel: [ 2041.893793] &nbsp;[&lt;ffffffff81151635&gt;] ? =
prep_new_page+0x145/0x1e0</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: =
[ 2041.893822] &nbsp;[&lt;ffffffffa03186ac&gt;] ? =
xfs_iext_bno_to_ext+0x8c/0x160 [xfs]</div><div>Oct &nbsp;4 12:51:21 =
ubuntu kernel: [ 2041.893826] &nbsp;[&lt;ffffffff81729d68&gt;] =
__down_common+0x9d/0xed</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ =
2041.893836] &nbsp;[&lt;ffffffffa02caffd&gt;] ? _xfs_buf_find+0xfd/0x2b0 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893839] =
&nbsp;[&lt;ffffffff81729e2b&gt;] __down+0x1d/0x1f</div><div>Oct &nbsp;4 =
12:51:21 ubuntu kernel: [ 2041.893847] &nbsp;[&lt;ffffffff8108e941&gt;] =
down+0x41/0x50</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ =
2041.893856] &nbsp;[&lt;ffffffffa02cae34&gt;] xfs_buf_lock+0x44/0x110 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893866] =
&nbsp;[&lt;ffffffffa02caffd&gt;] _xfs_buf_find+0xfd/0x2b0 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893875] =
&nbsp;[&lt;ffffffffa02cb284&gt;] xfs_buf_get_map+0x34/0x1b0 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893886] =
&nbsp;[&lt;ffffffffa02cc231&gt;] xfs_buf_read_map+0x31/0x130 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893900] =
&nbsp;[&lt;ffffffffa0302709&gt;] ? xfs_dabuf_map.isra.4+0x239/0x250 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893917] =
&nbsp;[&lt;ffffffffa0331c51&gt;] xfs_trans_read_buf_map+0x271/0x490 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893930] =
&nbsp;[&lt;ffffffffa030429f&gt;] xfs_da_read_buf+0xcf/0x230 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893942] =
&nbsp;[&lt;ffffffffa0304423&gt;] xfs_da3_node_read+0x23/0xd0 =
[xfs]</div><div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893946] =
&nbsp;[&lt;ffffffff8109147a&gt;] ? =
lg_local_unlock+0x1a/0x20</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: =
[ 2041.893950] &nbsp;[&lt;ffffffff811bd536&gt;] ? =
complete_walk+0xa6/0x120</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ =
2041.893961] &nbsp;[&lt;ffffffffa02e7f5b&gt;] =
xfs_attr_node_list+0x6b/0x4a0 [xfs]</div><div>Oct &nbsp;4 12:51:21 =
ubuntu kernel: [ 2041.893966] &nbsp;[&lt;ffffffff811bf14d&gt;] ? =
path_lookupat+0x6d/0x730</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ =
2041.893970] &nbsp;[&lt;ffffffff81729cb6&gt;] ? =
down_read+0x16/0x2b</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ =
2041.893983] &nbsp;[&lt;ffffffffa03161a4&gt;] ? xfs_ilock+0xf4/0x120 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.893995] =
&nbsp;[&lt;ffffffffa02e8645&gt;] xfs_attr_list_int+0xc5/0xe0 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.894007] =
&nbsp;[&lt;ffffffffa02e0e46&gt;] xfs_vn_listxattr+0x96/0x170 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.894019] =
&nbsp;[&lt;ffffffffa02e0b70&gt;] ? xfs_change_file_space+0x370/0x370 =
[xfs]</div><div>Oct &nbsp;4 12:51:21 ubuntu kernel: [ 2041.894024] =
&nbsp;[&lt;ffffffff811d654d&gt;] vfs_listxattr+0x4d/0x80</div><div>Oct =
&nbsp;4 12:51:21 ubuntu kernel: [ 2041.894027] =
&nbsp;[&lt;ffffffff811d65e9&gt;] listxattr+0x69/0x130</div><div>Oct =
&nbsp;4 12:51:21 ubuntu kernel: [ 2041.894030] =
&nbsp;[&lt;ffffffff811d718e&gt;] SyS_listxattr+0x4e/0x90</div><div>Oct =
&nbsp;4 12:51:21 ubuntu kernel: [ 2041.894034] =
&nbsp;[&lt;ffffffff81735cef&gt;] =
tracesys+0xe1/0xe6</div></div><div><br></div><div></div>------------------=
-------------------------- Test Script =
----------------------------------------<div><div>#! =
/bin/sh</div><div><br></div><div>#getfattr =
format</div><div>#</div><div># # file: foo</div><div># =
user.test=3D"test"</div><div><br></div><div>if [ $# !=3D "2" =
];</div><div>then</div><div>&nbsp; echo usage: $0 path =
count</div><div>&nbsp; exit =
1</div><div>fi</div><div><br></div><div>FILENAME=3D$1</div><div>COUNT=3D$2=
</div><div><br></div><div>rmdir $FILENAME &gt; /dev/null =
2&gt;&amp;1</div><div><br></div><div>datalen=3D65536</div><div>echo =
"datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatad=
atadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadat=
adatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatad=
atadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadat=
adatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatad=
atadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadat=
adatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata" =
&gt; tmp.$$</div><div>while test $datalen !=3D =
0</div><div>do</div><div>&nbsp; dd if=3Dtmp.$$ of=3Dsrc.$$ bs=3D512 =
count=3D1 conv=3Dnotrunc oflag=3Dappend 2&gt; /dev/null</div><div>&nbsp; =
datalen=3D`expr $datalen - 512`</div><div>done</div><div>rm =
tmp.$$</div><div><br></div><div>for len in 8 16 32 64 128 256 512 1024 =
2048 4096 8192 16384 32768 65536</div><div>do</div><div>&nbsp; mkdir =
$FILENAME</div><div><br></div><div>&nbsp; echo =
$len</div><div><br></div><div>&nbsp; count=3D0</div><div>&nbsp; while =
test $count !=3D $COUNT</div><div>&nbsp; do</div><div>&nbsp; &nbsp; =
entry=3Duser.test`expr $count + 1`</div><div>&nbsp; &nbsp; echo "# file: =
$FILENAME" &gt; data.$$</div><div>&nbsp; &nbsp; echo -n "$entry" =
&gt;&gt; data.$$</div><div>&nbsp; &nbsp; echo -n '=3D"' &gt;&gt; =
data.$$</div><div>&nbsp; &nbsp; dd if=3Dsrc.$$ of=3Ddata.$$ bs=3D$len =
count=3D1 conv=3Dnotrunc oflag=3Dappend 2&gt; /dev/null</div><div>&nbsp; =
&nbsp; echo '"' &gt;&gt; data.$$</div><div>&nbsp; &nbsp; #cat =
data.$$</div><div>&nbsp; &nbsp; #read a</div><div>&nbsp; &nbsp; setfattr =
--restore=3Ddata.$$</div><div>&nbsp; &nbsp; if [ $? !=3D "0" =
];</div><div>&nbsp; &nbsp; then</div><div>&nbsp; &nbsp; &nbsp; &nbsp; =
echo failure to set $entry</div><div>&nbsp; &nbsp; &nbsp; &nbsp; =
break</div><div>&nbsp; &nbsp; fi</div><div>&nbsp; &nbsp; count=3D`expr =
$count + 1`</div><div>&nbsp; &nbsp; #getfattr --dump =
$FILENAME</div><div>&nbsp; done</div><div>&nbsp; rm =
data.$$</div><div>&nbsp; rmcount=3D0</div><div>&nbsp; while test =
$rmcount !=3D $count</div><div><div>&nbsp; do</div><div>&nbsp; &nbsp; =
entry=3Duser.test`expr $rmcount + 1`</div><div>&nbsp; &nbsp; setfattr =
--remove=3D$entry $FILENAME</div><div>&nbsp; &nbsp; if [ $? !=3D "0" =
];</div><div>&nbsp; &nbsp; then</div><div>&nbsp; &nbsp; &nbsp; echo =
failure to remove $entry</div><div>&nbsp; &nbsp; &nbsp; =
break</div><div>&nbsp; &nbsp; fi</div><div>&nbsp; &nbsp; rmcount=3D`expr =
$rmcount + 1`</div><div>&nbsp; done</div><div>&nbsp; getfattr --dump =
$FILENAME</div><div>&nbsp; rmdir $FILENAME</div><div>done</div><div>rm =
src.$$</div><div><br></div><div>exit =
0</div></div><div><br></div><div>-----------------------------------------=
-----------------------------------------------</div><meta =
http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"><div></div><div><br></div><div>
<div style=3D"color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
medium; font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
-webkit-auto; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div>David Zafman</div><div>Senior Developer</div><div><a =
href=3D"http://www.inktank.com">http://www.inktank.com</a></div><div><br><=
/div></div><br class=3D"Apple-interchange-newline"><br =
class=3D"Apple-interchange-newline">
</div>
<br></div></body></html>=

--Apple-Mail=_5CCEB2A4-B0FD-4058-B53F-B11D32757AE9--


--===============3277510080828472255==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3277510080828472255==--
