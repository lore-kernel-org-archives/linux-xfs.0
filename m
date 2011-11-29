Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATFcVe9069769 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 09:38:31 -0600
Date: Tue, 29 Nov 2011 09:38:50 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: Remove the entries from the queue while waking
	them up
Message-ID: <20111129153850.GU29840@sgi.com>
References: <1321918880.7115.5.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321918880.7115.5.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Hey Chandra,

On Mon, Nov 21, 2011 at 05:41:20PM -0600, Chandra Seetharaman wrote:
> Changes from Verion 1:
> 
> - Added additional comments as per Dave's suggestion
> - Use next instead of tmp
> - change typedef xlog_ticket_t to struct xlog_ticket
> - Check t_queue before adding it to the list (the second time)
>   to accomodate system events (based on Christoph's comments)

FWIW, I reproduced a log hang yesterday in xfstest 273 while testing
this patch.  We'll have to see if Christoph's revision fares any better
today.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
