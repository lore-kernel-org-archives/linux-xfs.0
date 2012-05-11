Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BGaCtc071232 for <xfs@oss.sgi.com>; Fri, 11 May 2012 11:36:12 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id h0dY4uELchum4JTH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 May 2012 09:36:10 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so3269315yhj.26
	for <xfs@oss.sgi.com>; Fri, 11 May 2012 09:36:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CBD2D5A5.7C6B%Marcus.Hammer@auma.com>
References: <CBD2D5A5.7C6B%Marcus.Hammer@auma.com>
Date: Fri, 11 May 2012 18:36:09 +0200
Message-ID: <CAAxjCEyXa-5aS=Pik8VgtnCM++hpraPsOsHR+-Lasa2znjgw9Q@mail.gmail.com>
Subject: Re: Strange problems with xfs an SLESS11 SP2
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
To: "Hammer, Marcus" <Marcus.Hammer@auma.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> The /disk5 is a frequent accessed xfs filesystem by the ERP system. The disk usage increased from 53% to 76-78%. But only the disk usage, the size of the files are completely the same.

Is it possible that this is caused by the aggressive pre-allocation?
There is a mount option (allocsize, I think) that allows you to
override this behavior.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
