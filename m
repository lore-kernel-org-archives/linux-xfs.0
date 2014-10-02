Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 160887F4E
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 06:32:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 03EF78F8033
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 04:32:08 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 48ZKkfc5W6AGnx76 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 04:32:07 -0700 (PDT)
Date: Thu, 2 Oct 2014 13:32:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Happened again, 20140930 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20141002113205.GE19748@quack.suse.cz>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>
	<20141001004514.GH24490@dastard> <542B6B8A.2060309@opensuse.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <542B6B8A.2060309@opensuse.org>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed 01-10-14 04:48:42, Carlos E. R. wrote:
> On 2014-10-01 02:45, Dave Chinner wrote:
> >On Wed, Oct 01, 2014 at 12:27:20AM +0200, Carlos E. R. wrote:
> 
> >We've already got the fix in our upstream repository:
> >
> >8018ec0 xfs: mark all internal workqueues as freezable
> >
> >It's currently in linux-next, queued for the next merge window. You
> >shoul dprobably talk to your distro about getting it backported.
> 
> Wow, thanks. I'll tell them.
> 
> Question: where does it apply, kernel, xfsprogs? They will know, but
> I don't, and I need that info for the bugzilla "component" field ;-)
  Feel free to assign that bug to me (jack@suse.com in bugzilla) and I'll
take care of it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
