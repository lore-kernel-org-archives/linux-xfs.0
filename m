Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D49177F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 10:38:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2C738F8035
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 08:37:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CQj0vLIKqmPFY6aH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 08:37:58 -0800 (PST)
Date: Mon, 12 Jan 2015 11:37:50 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: extremely slow file creation/deletion after xfs ran full
Message-ID: <20150112163749.GE25944@bfoster.bfoster>
References: <54B387A1.6000807@aei.mpg.de> <54B3CC6A.4080405@aei.mpg.de>
	<20150112155206.GD25944@bfoster.bfoster>
	<54B3F19D.6030307@aei.mpg.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B3F19D.6030307@aei.mpg.de>
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
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

On Mon, Jan 12, 2015 at 05:09:01PM +0100, Carsten Aulbert wrote:
> Hi Brian
> 
> On 01/12/2015 04:52 PM, Brian Foster wrote:
> > I can't see any symbols associated with the perf output. I suspect
> > because I'm not running on your kernel. It might be better to run 'perf
> > report -g' and copy/paste the stack trace for some of the larger
> > consumers.
> > 
> 
> Sorry, I rarely need to use perf and of course forgot that the
> intermediate output it tightly coupled to the running kernel. Attaching
> the output of perf report -g here.

It does look like we're spending most of the time down in
xfs_diallog_ag(), which is the algorithm for finding a free inode in the
btree for a particular AG when we know that existing records have some
free.

> > 
> > Sounds good. FWIW, something like the following should tell us how many
> > free inodes are available in each ag, and thus whether we have to search
> > for free inodes in existing records rather than allocate new ones:
> > 
> > for i in $(seq 0 15); do
> > 	xfs_db -c "agi $i" -c "p freecount" <dev>
> > done
> > 
> Another metric :)
> 
> freecount = 53795884
> freecount = 251
> freecount = 45
> freecount = 381
> freecount = 11009
> freecount = 6748
> freecount = 663
> freecount = 595
> freecount = 693
> freecount = 9089
> freecount = 37122
> freecount = 2657
> freecount = 60497
> freecount = 1790275
> freecount = 54544
> 
> That looks... not really uniform to me.
> 

No, but it does show that there are a bunch of free inodes scattered
throughout the existing records in most of the AGs. The finobt should
definitely help avoid the allocation latency when this occurs.

It is interesting that you have so many more free inodes in ag 0 (~53m
as opposed to several hundreds/thousands in others). What does 'p count'
show for each ag? Was this fs grown to the current size over time?

Brian

> Cheers
> 
> Carsten
> 
> 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
