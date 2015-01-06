Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9A267FAB
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 13:05:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8634304053
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:05:20 -0800 (PST)
Received: from mail-yk0-f169.google.com (mail-yk0-f169.google.com
	[209.85.160.169]) by cuda.sgi.com with ESMTP id
	xfAWdc7wWwuqaUaF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 11:05:19 -0800 (PST)
Received: by mail-yk0-f169.google.com with SMTP id 79so11551951ykr.14
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 11:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54AC1511.1060908@sandeen.net>
References: <1806495.BCZcrVVEOf@shtub-cm>
	<54AC1511.1060908@sandeen.net>
Date: Tue, 6 Jan 2015 12:05:17 -0700
Message-ID: <CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
From: Chris Murphy <lists@colorremedies.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jan 6, 2015 at 10:02 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> however, some drives lie about these sizes, and then mkfs.xfs can't know.
> Try the blockdev command above to see.

blockdev and parted seem to get this wrong for a device for which
smartctl and hdparm get correct


smartctl -a reports:
Sector Sizes:     512 bytes logical, 4096 bytes physical
hdparm -I reports:
Logical  Sector size:                   512 bytes
Physical Sector size:                  4096 bytes

parted reports:
Sector size (logical/physical): 512B/512B

# blockdev --getss /dev/sdc
512
# blockdev --getpbsz /dev/sdc
512

And thus xfs_info on this device says sectsz=512 since I formatted
with defaults.



-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
