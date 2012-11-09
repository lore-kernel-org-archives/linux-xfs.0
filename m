Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9F1O9h118611 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 09:01:24 -0600
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id hCBp3KNuVPjRODM6 for
	<xfs@oss.sgi.com>; Fri, 09 Nov 2012 07:03:22 -0800 (PST)
Subject: Re: How to reserve disk space in XFS to make the blocks over many
	files continuous?
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20121107031952.GA6434@dastard>
References: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
	<20121107031952.GA6434@dastard>
Date: Fri, 09 Nov 2012 15:03:21 +0000
Message-Id: <1352473401.3179.48.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: huubby zhou <huubby1@gmail.com>, xfs@oss.sgi.com


> > My question is, how can I guarantee the file system blocks over files
> > continuous? Thanks for your time and appreciate your answer.
> 
> You can't, directly. 

We needed to do this so I added code to swapext to support transferring
leading blocks from one (preallocated single extent) file to another
empty file. It's pretty straightforward but perhaps too special case for
general consumption.

-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
