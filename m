Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8AECD7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 18:28:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76C9F304066
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:28:36 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id dFGIkXmnSJY21Qop (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 16:28:25 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 15 May 2013 17:28:12 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B9B5219D8036
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:27:56 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP
	id r4FNS3dk218622
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:28:03 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r4FNRTJ4016677
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:28:02 -0600
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <519404A0.3030401@gmail.com>
References: <5191FB46.2080300@gmail.com>
	<1368650489.10223.5.camel@chandra-dt.ibm.com>
	<519404A0.3030401@gmail.com>
Date: Wed, 15 May 2013 17:12:48 -0500
Message-ID: <1368655968.10223.24.camel@chandra-dt.ibm.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, 2013-05-15 at 17:56 -0400, Michael L. Semon wrote:
Hi Michael,

Irrespective of the user space changes, this patchset should work
properly with the current tools and existing filesystems providing
current behavior.

Let me know of the anomalies as the ones below.

Thanks

Chandra 
> On 05/15/2013 04:41 PM, Chandra Seetharaman wrote:
> > On Tue, 2013-05-14 at 04:52 -0400, Michael L. Semon wrote:
> >> Hi!  I seem to have no luck in getting v8 of the pquota/uquota patchset
> >> working and have it pass xfstests with flying colors.  Is v8 of the
> >> pquota/gquota patchset sufficient to make the new separate pquota/gquota
> >> bits work?  Or is it an incremental patchset?
> >
> > Hi Michael,
> >
> > I will post the user level changes that accompanies these changes.
> >
> > With those changes you can do a new mkfs and use pquota and gquota
> > together.
> >
> > Regards,
> >
> > Chandra
> 
> Excellent!
> 
> As for the rest of your issues, I'll have to retest very slowly using 
> your new userspace patches, documenting every step in order.  It will 
> also require before/after runs of xfstests.
> 
> I do not know what your patches do for filesystems that already had 
> quota on them, so I ask you to check one thing.  It looked like the 
> result of the normal `quota` command was having issues.  On my root 
> filesystem that was mounted uquota only, the following is the normal 
> behavior (as an ordinary user):
> 
> mls:~$ quota
> Disk quotas for user mls (uid 3001):
>       Filesystem  blocks   quota   limit   grace   files   quota   limit 
>    grace
>        /dev/sda1  165955  262144  327680            2345    8194   16384
> 
> However, before I switched out kernels here, such a command just left a 
> blank, as if there was no quota there.  If you would at that to your 
> list of spot-check tests, that would be great.  It might work fine for 
> you.  [For the same situation, `xfs_quota -c quota /` worked just fine.]
> 
> You're leading a blind man in the dark, so I thank you for your patience.
> 
> Michael
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
