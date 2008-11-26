Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ43ldH006009 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 22:03:47 -0600
Received: from Russell-Cattelans-MacBook.local (slurp.thebarn.com
	[208.42.117.201]) (authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mAQ3aTB7005920;
	Tue, 25 Nov 2008 21:36:29 -0600 (CST)
	(envelope-from cattelan@xfs.org)
Message-ID: <492CC43D.8020704@xfs.org>
Date: Tue, 25 Nov 2008 21:36:29 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492C7160.80208@sgi.com>
In-Reply-To: <492C7160.80208@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: markgw@sgi.com
Cc: xfs@oss.sgi.com

Mark Goodwin wrote:
>
>
> Russell Cattelan wrote:
>> Christoph Hellwig wrote:
>>> On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
>>>
>>>> There's a few branches there already:
>>>>
>>>> 'master'      This will contain all the latest xfs changes not yet 
>>>> pushed
>>>>                to mainline.
>>>> 'mainline'    This is vanilla mainline and will updated regularly.
>>>> 'for-linus'   Our staging branch for pull requests
>>>> 'xfs-dev'     This branch will contain KDB and other supporting 
>>>> code for
>>>>                development and should be identical to the old CVS 
>>>> tree.
>>>>
>>>> Feel free to start using it and let us know if you have any issues.
>>>>
>>> Any chance to have these as separate git trees instead of branches?
>
> Why? Is it just a bandwidth issue with the initial clone, or some
> other reason?
>
>>> In either case, do you expect patches against the xfs-dev or the master
>>> tree?
>
> I'll let Lachlan reply to that, but normally master I think. One thing 
> that
> is important is that any commit against the xfs-dev tree should split out
> kdb and dmapi changes into separate commits from changes to fs/xfs.
>
>>  It would also be useful if the trees and which one to be used
>>> could be documented on oss.sgi.com/projects/xfs or xfs.org.
>
> yes certainly.
>
>> Specifically this page please.
>> http://xfs.org/index.php/Getting_the_latest_source_code
>
> Been waiting for the WIKI on oss to be set up - these two sites
> can simply mirror each other I guess for some or all documentation.
I suppose we could just move the xfs.org wiki to oss (once the machine 
is up/upgraded/wiki installed)
>
>> Maybe add a quick tutorial on git branches and how to create tracking
>> branches for this tree.
>
> Yes that's a good idea: git remote add ....
>
>> Also can we have something other than "unnamed repository" in the
>> description file?
>
> Yep. Niv, can you fix that up please.
>
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
> Russell, would it be possible somehow for this footer to include the URL
> of the archive reference for the message containing it?
Hmm that my be difficult since the archive web stuff is generated 
periodically after that fact,
so I'm not sure if mailman has the ability build the url as part of 
sending out the email.

I'll do some googling and see if it is possible.
>
> Cheers
> -- Mark
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
