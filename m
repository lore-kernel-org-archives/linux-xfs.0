Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F9MRDb104959 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 04:22:27 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	m7d9N7i5k61mVItP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Aug 2012 02:22:26 -0700 (PDT)
Received: by obbup19 with SMTP id up19so2086131obb.26
	for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 02:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502B6884.2010402@profihost.ag>
References: <502AB82D.9090408@profihost.ag> <1850094.RmMErZaXcJ@saturn>
	<502B6884.2010402@profihost.ag>
Date: Wed, 15 Aug 2012 11:22:25 +0200
Message-ID: <CAAxjCEw+PY569Hz79_JFWBxg662CtAqciKU=w+fh76oiNHbZ0A@mail.gmail.com>
Subject: Re: aborted SCSI commands while discarding/unmapping via mkfs.xfs
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

> right now a self build test system running http://www.nexenta.com/corp/.

With SAS disks or SATA? This seems to make a big difference regarding
how much a long-running operation can lock out concurrent accesses.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
