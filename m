Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 724E47F5E
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:31:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 611BA8F8033
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:31:49 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id u5NDXy2bFKtLxrOm for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 21:31:45 -0800 (PST)
Message-ID: <54ACC4C0.2030802@sandeen.net>
Date: Tue, 06 Jan 2015 23:31:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
References: <1806495.BCZcrVVEOf@shtub-cm>
	<54AC1511.1060908@sandeen.net>	<CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>	<54AC363E.1090109@sandeen.net>	<CAJCQCtRUq9ozu74TBjm4G-yoC0kQa7Vr8nUTNzke6O7DTWQPXw@mail.gmail.com>
	<CAJCQCtS8M5w76bzr4TzB9CQo+tTOwsfAu8+x5h7p9W_RMfEgFA@mail.gmail.com>
In-Reply-To: <CAJCQCtS8M5w76bzr4TzB9CQo+tTOwsfAu8+x5h7p9W_RMfEgFA@mail.gmail.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/6/15 1:55 PM, Chris Murphy wrote:
> What's sectsz= used for? Historically this would be sectsz=512,
> bsize=4096 before AF hard drives appeared. So is sectsz used for
> optimizing sub blocksize changes? e.g. if only 50 bytes needs
> changing, the fs doesn't need to read modify and write the entire 4096
> block, just change the affected sector?

Nope, filesystem data blocks are always fully written, but the sector
size is i.e. the minimum _log_ IO size.

+/*
+ * The xfs_buftarg contains 2 notions of "sector size" -
+ *
+ * 1) The metadata sector size, which is the minimum unit and
+ *    alignment of IO which will be performed by metadata operations.
+ * 2) The device logical sector size
+ *
+ * The first is specified at mkfs time, and is stored on-disk in the
+ * superblock's sb_sectsize.
+ *
+ * The latter is derived from the underlying device, and controls direct IO
+ * alignment constraints.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
