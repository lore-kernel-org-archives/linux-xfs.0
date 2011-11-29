Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATNOWsX115268 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 17:24:33 -0600
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 085B04D43BF
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 15:24:31 -0800 (PST)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id hKvPc6SHYKmEmSTP for
	<xfs@oss.sgi.com>; Tue, 29 Nov 2011 15:24:31 -0800 (PST)
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 29 Nov 2011 18:24:30 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pATNOS1T311054 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 18:24:28 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	pATNOSbu008982 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 21:24:28 -0200
Subject: Re: [PATCH v2] xfs: Remove the entries from the queue while waking
	them up
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111129153850.GU29840@sgi.com>
References: <1321918880.7115.5.camel@chandra-lucid.austin.ibm.com>
	<20111129153850.GU29840@sgi.com>
Date: Tue, 29 Nov 2011 17:24:25 -0600
Message-ID: <1322609065.7115.1541.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-11-29 at 09:38 -0600, Ben Myers wrote:
> Hey Chandra,
> 
> On Mon, Nov 21, 2011 at 05:41:20PM -0600, Chandra Seetharaman wrote:
> > Changes from Verion 1:
> > 
> > - Added additional comments as per Dave's suggestion
> > - Use next instead of tmp
> > - change typedef xlog_ticket_t to struct xlog_ticket
> > - Check t_queue before adding it to the list (the second time)
> >   to accomodate system events (based on Christoph's comments)
> 
> FWIW, I reproduced a log hang yesterday in xfstest 273 while testing

I didn't have test case 273 in my test directory (old copy). Ran the
tests and did see hang and some list corruption. I haven't gone further.

> this patch.  We'll have to see if Christoph's revision fares any better
> today.

I tried testcase 273 with Christoph patches and they are running fine
for few runs now.

I will run test cases 273 and 234 overnight with Christoph's patches and
report it tomorrow.

> 
> Thanks,
> 	Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
