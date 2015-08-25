Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C0CE7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 09:54:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B59D30404E
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 07:54:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MJkT7E2DgRcCFEW8 for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 07:54:01 -0700 (PDT)
Message-ID: <55DC8188.5060004@sandeen.net>
Date: Tue, 25 Aug 2015 09:54:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: hello, my xfs has a probelm. does anybody know this?thank you
References: <7B5C2F2226F8AF419D625C6097AD814C5E26FE9C@H3CMLB12-EX.srv.huawei-3com.com>
In-Reply-To: <7B5C2F2226F8AF419D625C6097AD814C5E26FE9C@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "zhengbin.08747@h3c.com" <zhengbin.08747@h3c.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 8/25/15 4:08 AM, zhengbin.08747@h3c.com wrote:
> My OS is redhat7.1, the version of Linux kernel is =93Linux version 3.10.=
0-229.el7.x86_64=94
> =

> Sometime xfs give a message like this
> =

> Aug 11 15:51:05 localhost kernel: XFS (dm-4): metadata I/O error: block 0=
x7d9a010 ("xfs_trans_read_buf_map") error 117 numblks 16
> Aug 11 15:51:05 localhost kernel: XFS (dm-4): xfs_imap_to_bp: xfs_trans_r=
ead_buf() returned error 117. =

> Aug 11 15:31:08 localhost kernel: XFS (dm-4): Metadata corruption detecte=
d at xfs_inode_buf_verify+0x75/0xd0 [xfs], block 0x7d9a010
> Aug 11 15:31:08 localhost kernel: XFS (dm-4): Unmount and run xfs_repair

Did you try running xfs_repair (or possibly better for the first run, do xf=
s_repair -n, to do a check-only run?)

> Aug 11 15:31:08 localhost kernel: XFS (dm-4): First 64 bytes of corrupted=
 metadata buffer:
> Aug 11 15:31:08 localhost kernel: ffff88089144a000: 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00  ................
> Aug 11 15:31:08 localhost kernel: ffff88089144a010: 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00  ................
> Aug 11 15:31:08 localhost kernel: ffff88089144a020: 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00  ................
> Aug 11 15:31:08 localhost kernel: ffff88089144a030: 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00  ................

So it seems to have read a completely zeroed-out block.

Isn't there a stack trace after this part of the message?
Hm I guess not; if you can hit it again, try =


# sysctl -w fs.xfs.error_level=3D11

to turn up the error reporting level.


Any chance that this is a thinly provisioned device?  Or what type of dm de=
vice is it?

> So is this a bug of xfs? or is the device=92s error(the device actually d=
id not save the data, but give xfs success message)?

Hard to say at this point.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
