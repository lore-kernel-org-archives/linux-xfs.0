Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 18:23:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9H1N2aG029209
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 18:23:06 -0700
Message-Id: <200610170122.LAA26844@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: LEAFN node level is N -- bogus warning
Date: Tue, 17 Oct 2006 11:25:34 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <002601c6d687$ad012420$6701a8c0@BODDINGTON>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Roger Willcocks' <roger@filmlight.ltd.uk>, xfs@oss.sgi.com

Hi Roger,

Just to let you know, I now have a filesystem that is displaying this
warning, so I am looking into it in combination with your patch. I'll let
you know how it goes.

Regards,
Barry. 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Roger Willcocks
> Sent: Wednesday, 13 September 2006 2:23 AM
> To: xfs@oss.sgi.com
> Subject: LEAFN node level is N -- bogus warning
> 
> In xfs_repair / dir2.c there's a check for the 'level' of a 
> directory leaf node within the btree hierarchy. A warning 
> 'LEAFN node level is N' is generated if the level >= 1.
>  
> But leaf nodes don't have a /level/ member, although internal 
> nodes do (compare xfs_dir2_leaf_hdr_t and xfs_da_intnode_t). 
> xfs_repair is actually testing leaf->hdr.stale - so the 
> warning is bogus.
>  
> The attached patch removes the test and make the relationship 
> between magic numbers and pointer types more explicit.
>  
> --
> Roger
>  
>  
> 
