Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 794067F84
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:51:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5996230404E
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 13:51:02 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id n6So0kWj6ofnHXP8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 13:51:01 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 13 Aug 2013 21:51:00 +0100
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 1D5B76E803C
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:50:53 -0400 (EDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7DKowu134013402
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:50:58 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7DKouoc023098
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 14:50:56 -0600
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <520A9A2F.5090009@sgi.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<520A9A2F.5090009@sgi.com>
Date: Tue, 13 Aug 2013 15:50:48 -0500
Message-ID: <1376427048.971.17.camel@chandra-dt.ibm.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>

On Tue, 2013-08-13 at 15:42 -0500, Rich Johnston wrote:
> Hey Chandra,
> 
> Nice addition to quotas.  Just a couple of comments.
> 
> On 08/06/2013 05:27 PM, Chandra Seetharaman wrote:
> 
> . . .
> >
> > +/*
> > + * fs_quota_statv is the used by Q_XGETQSTATV for a given file system. It
> Remove extra word       ^^^^
> 
> > + * provides a centralized way to get meta information about the quota
> > + * subsystem. eg. space taken up for user, group, and project quotas, number
> > + * of dquots currently incore.
> > + *
> > + * This version has proper versioning support with appropriate padding for
> > + * future expansions, and ability to expand for future without creating any
> > + * backwward compatibility issues.
> backward is misspelled (extra w)
> 
> > + *
> > + * For Q_XGETQSTATV, user space caller need to specify fs_quota_statv.qs_version
> > + * to the version of data they are interested in. Kernel will fill the data
> > + * fields relevant to that version.
> > + *
> > + * If kernel does not support user space caller specified version, EINVAL will
> > + * be returned. User space caller can then reduce the version number and retry
> > + * the same command.
> > + */
> This was a little difficult to follow, suggest rewording a little, 
> something like:
> 
> Q_XGETQSTATV uses the passed in value of the requested version via
> fs_quota_statv.qs_version to determine the return data layout of 
> fs_quota_statv.
> 
> 

Will make all the suggested fixes.

> It would be nice to get this information documented in the quotactl(2)
> manpage similar to Q_XGETQSTAT.

Once it is in the kernel will work with Jan Kara to add the relevant
changes to user space.

Thanks

Chandra
> 
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
