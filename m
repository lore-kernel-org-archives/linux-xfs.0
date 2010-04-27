Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3R9Uvgd149868 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 04:30:57 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A4732F4653
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 02:33:00 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id jnOKIyERa4CYUnEN for
	<xfs@oss.sgi.com>; Tue, 27 Apr 2010 02:33:00 -0700 (PDT)
Date: Tue, 27 Apr 2010 11:32:50 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: O_SYNC behavior?
Message-ID: <20100427093250.GA15182@citd.de>
References: <20100426225627.GA7106@esri.com>
	<537687191.239471272324343715.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <537687191.239471272324343715.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nathans@aconex.com>
Cc: xfs@oss.sgi.com, Ray Van Dolson <rvandolson@esri.com>

On 27.04.2010 09:25, Nathan Scott wrote:
> 
> ----- "Ray Van Dolson" <rvandolson@esri.com> wrote:
> 
> > End-user question:
> > 
> > NFS client accessing an NFS export on an XFS based filesystem via
> > "sync" (O_SYNC) mode.
> > 
> > Will write confirmation be sent back from the NFS server when the
> > data is written to the xfs journal,
> 
> Data is never written to the journal.

I don't think that answers the intented question.

I guess the correct answer is:
It depends on the server-side configuration.
An "async" export gets the "done"-answer immediatly.
An "sync" export (only when also mounted "sync" AFAIU) waits at least 
until the write command is send down the stack, maybe even until the 
data actually hit the platters or silicon in the SSD-case.

man 5 exports:
- snip -
sync:	Reply to requests only after the changes have been committed to stable storage
- snip -

But i guess the performance will be horrible when both side are "sync".




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
