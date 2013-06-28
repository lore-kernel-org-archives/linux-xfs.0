Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBD6A7F5D
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:15:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53C99AC001
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:15:00 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id y14pCmzpHN87BEng (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 11:14:59 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 28 Jun 2013 12:14:59 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 84D6B1FF0022
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 12:09:41 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5SIEYcX128950 for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 12:14:54 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5SIEYIP001103
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 12:14:34 -0600
Subject: Re: [PATCH v10 05/11] xfs: Do some whitespace cleanup in the data
	structure xfs_quotainfo
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130628163058.GW20932@sgi.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-6-git-send-email-sekharan@us.ibm.com>
	<20130628163058.GW20932@sgi.com>
Date: Fri, 28 Jun 2013 13:14:33 -0500
Message-ID: <1372443273.8341.207.camel@chandra-dt.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, 2013-06-28 at 11:30 -0500, Ben Myers wrote:
> Hey Chandra,
> 
> On Thu, Jun 27, 2013 at 05:25:08PM -0500, Chandra Seetharaman wrote:
> > In preparation for combined pquota/gquota support, do some
> > whitespace cleanups.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Wow.  Putting this in a patch by itself really puts it into stark
> relief.
> 
> If we pull this in we're representing that some tabs and the alignment
> of the fields is more valuable than the comments?  I'm fairly certain I


If you put it that way, it does sound not correct, and I would agree
with you too :). 

But, IMO, it has to be more subjective than that. The comments removed,
IMO, add no additional value (the field name conveys the same
information). You can see that I left alone the comments that provide
some value.

> don't agree that's the case...
> 
> I'm sorry for your trouble, but I think I should pass on this one.  Do
> you agree?
> 

In effect, the code does look better (than I found it :) at the cost of
removal of redundant comments.

If you still don't want to include, I would accept your decision.

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
