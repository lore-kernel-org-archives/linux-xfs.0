Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3B367F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 05:59:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D001C30404E
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 03:59:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LEsoz7uIwTgqDtPs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2015 03:59:02 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id E1A6D8F013
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 11:59:01 +0000 (UTC)
Date: Wed, 9 Dec 2015 06:59:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfsprogs: Removal of trailing whitespaces
Message-ID: <20151209115900.GA45171@bfoster.bfoster>
References: <CACj3i73f4_KZ8qUN4Gqz_bg3TCTbgdsg9PZ6UvMSRm+9JHN0JA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i73f4_KZ8qUN4Gqz_bg3TCTbgdsg9PZ6UvMSRm+9JHN0JA@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 08, 2015 at 07:48:31PM +0100, Jan Tulak wrote:
> Hi,
> 
> I decided to remove trailing whitespaces on various locations in the code
> of xfsprogs, mainly because I have enabled highlighting of these, and they
> were flashing into my eyes whenever I scrolled around. :-)
> 
> I looked for the last commit touching some of the lines with trailing
> blanks and in all cases I found that the lines were last changed in 2011 or
> earlier. Maybe there can be something newer, I didn't checked the story of
> every one, but it seems that they are here for a long time, and will be
> still if I don't remove them.
> 
> Right now, I have 14 patches, one for every tool/directory, where some
> change occurred. About 140 lines changed in 52 files in total. I thought
> that separating it this way makes for easier fix if it causes a conflict
> with some other patch, however I can merge them into a single patch.
> 
> Should I send it separated as it is, or merge it into a single patch?
> 

A single patch makes for less noise in the commit log, IMO.

Brian

> Cheers,
> Jan
> 
> -- 
> Jan Tulak
> jtulak@redhat.com / jan@tulak.me

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
