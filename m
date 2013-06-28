Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C40E7F61
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:31:05 -0500 (CDT)
Date: Fri, 28 Jun 2013 13:31:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v10 05/11] xfs: Do some whitespace cleanup in the data
	structure xfs_quotainfo
Message-ID: <20130628183104.GY20932@sgi.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-6-git-send-email-sekharan@us.ibm.com>
	<20130628163058.GW20932@sgi.com>
	<1372443273.8341.207.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372443273.8341.207.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

Hey Chandra,

On Fri, Jun 28, 2013 at 01:14:33PM -0500, Chandra Seetharaman wrote:
> On Fri, 2013-06-28 at 11:30 -0500, Ben Myers wrote:
> > Hey Chandra,
> > 
> > On Thu, Jun 27, 2013 at 05:25:08PM -0500, Chandra Seetharaman wrote:
> > > In preparation for combined pquota/gquota support, do some
> > > whitespace cleanups.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > Wow.  Putting this in a patch by itself really puts it into stark
> > relief.
> > 
> > If we pull this in we're representing that some tabs and the alignment
> > of the fields is more valuable than the comments?  I'm fairly certain I
> 
> 
> If you put it that way, it does sound not correct, and I would agree
> with you too :). 
> 
> But, IMO, it has to be more subjective than that. The comments removed,
> IMO, add no additional value (the field name conveys the same
> information). You can see that I left alone the comments that provide
> some value.

I did notice that you kept some of the comments.  However, I am finding some of
the removed ones to be useful too.  I think if you try to look at this
structure with the eyes of a newbie the comments do help you.  e.g.
di_btimelimit doesn't carry much meaning for me out of context, and the comment
is helping me, at least.  Not everyone is quite so moronic as me, though.  ;)

> > don't agree that's the case...
> > 
> > I'm sorry for your trouble, but I think I should pass on this one.  Do
> > you agree?
> > 
> 
> In effect, the code does look better (than I found it :) at the cost of
> removal of redundant comments.
> 
> If you still don't want to include, I would accept your decision.

Thanks.  I really would prefer to keep them.  FWIW, the rest of your patch set
doesn't appear to be adversely affected by doing so.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
