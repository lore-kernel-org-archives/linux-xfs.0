Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A29E97FB9
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 13:55:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E9A1AC007
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:55:49 -0800 (PST)
Received: from mail-yk0-f174.google.com (mail-yk0-f174.google.com
	[209.85.160.174]) by cuda.sgi.com with ESMTP id
	iVfI0yG6t4kRM3K3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 11:55:47 -0800 (PST)
Received: by mail-yk0-f174.google.com with SMTP id 10so11565253ykt.33
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 11:55:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRUq9ozu74TBjm4G-yoC0kQa7Vr8nUTNzke6O7DTWQPXw@mail.gmail.com>
References: <1806495.BCZcrVVEOf@shtub-cm> <54AC1511.1060908@sandeen.net>
	<CAJCQCtQqseJ_75WSjqqNMmSjYW-0-L_cWBDDECRVOkiTmHLeVA@mail.gmail.com>
	<54AC363E.1090109@sandeen.net>
	<CAJCQCtRUq9ozu74TBjm4G-yoC0kQa7Vr8nUTNzke6O7DTWQPXw@mail.gmail.com>
Date: Tue, 6 Jan 2015 12:55:47 -0700
Message-ID: <CAJCQCtS8M5w76bzr4TzB9CQo+tTOwsfAu8+x5h7p9W_RMfEgFA@mail.gmail.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

What's sectsz= used for? Historically this would be sectsz=512,
bsize=4096 before AF hard drives appeared. So is sectsz used for
optimizing sub blocksize changes? e.g. if only 50 bytes needs
changing, the fs doesn't need to read modify and write the entire 4096
block, just change the affected sector?

If that's true, then sectsz=512 for a 4096 physical sector drive would
cause a lot of in-drive RMW, depending on the workdlow. On older AF
drives this can be a huge penalty hit.


Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
