Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 01:49:18 -0700 (PDT)
Received: from web31713.mail.mud.yahoo.com (web31713.mail.mud.yahoo.com [68.142.201.193])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k778mwDW024819
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 01:49:02 -0700
Message-ID: <20060807084830.58133.qmail@web31713.mail.mud.yahoo.com>
Date: Mon, 7 Aug 2006 01:48:30 -0700 (PDT)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: Re: Concurrent mount of XFS over SAN
In-Reply-To: <44D26D3E.5010708@exegy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Lloyd <dlloyd@exegy.com>
Cc: xfs@oss.sgi.com

Dave, 
That's 100% correct assuming you prohibit a shared access between the
nodes. I didn't point out that we're dealing with filesystem failover
setup.
It's obvious that I can always fall back to the inter-node heart-beat
to ensure that only one node is mounting the filesystem.
I'm just wondering if there's any facility or accepted practice to
enforce it.

Thanks,
Alan

--- Dave Lloyd <dlloyd@exegy.com> wrote:

> Heilige Gheist wrote:
>  > Is there a way to prevent and/or detect concurrent mount of same
> XFS
>  > SAN-based partition from several nodes?
>  > I had to fsck a filesystem losing some data after two nodes
> happily
>  > mounted a filesystem from same SAN-based partition at the same
> time and
>  > wrote into it.
>  > Thanks!
>  >
>  > --alan
>  >
>  > __________________________________________________
>  > Do You Yahoo!?
>  > Tired of spam?  Yahoo! Mail has the best spam protection around
>  > http://mail.yahoo.com
>  >
>  >
> 
> I think that the generally accepted way is to zone at the switch or
> the
> storage array.
> 
> -- 
> Dave Lloyd
> Test Engineer, Exegy, Inc.
> 314.450.5342
> dlloyd@exegy.com
> 
> 
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
