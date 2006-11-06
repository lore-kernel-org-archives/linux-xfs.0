Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Nov 2006 05:43:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA6DgwaG013782
	for <xfs@oss.sgi.com>; Mon, 6 Nov 2006 05:42:59 -0800
Received: from rrzmta2.rz.uni-regensburg.de (rrzmta2.rz.uni-regensburg.de [132.199.1.17])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A494508757
	for <xfs@oss.sgi.com>; Mon,  6 Nov 2006 05:42:09 -0800 (PST)
Date: Mon, 6 Nov 2006 14:41:48 +0100
From: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <20061106134148.GA25180@pc51072.physik.uni-regensburg.de>
Reply-To: christian.guggenberger@physik.uni-regensburg.de
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <454A3B28.7010405@sandeen.net> <20061103093203.GA18010@pc51072.physik.uni-regensburg.de> <20061103123418.GP8394166@melbourne.sgi.com> <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Nov 03, 2006 at 04:44:48PM +0100, Christian Guggenberger wrote:
> > 
> > xfs_db mojo.... ;)
> > 
> > Note - no guarantee this will work - practise on an expendable
> > sparse loopback filessytem image by making a filesystem of slightly less
> > than 16TB then growing it to corrupt it the same way and then fixing it up
> > successfully.
> > 
...

> 
> (btw, I still hope they get access to an 64bit system with recent
> xfsprogs and kernel, soon)
>
for your info - with recent xfsprogs (2.8.11) repair (on a 32bit system)
succeeded. No xfs_db magic needed. 

thanks again for your help,

cheers.
 - Christian
