Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBA07QVd029102 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 18:07:28 -0600
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mBA07EAb078613;
	Tue, 9 Dec 2008 18:07:15 -0600 (CST) (envelope-from cattelan@xfs.org)
Message-ID: <493F0831.8030405@xfs.org>
Date: Tue, 09 Dec 2008 18:07:13 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com>
	<20081125081644.GA20644@infradead.org>	<492C0B3D.3040002@thebarn.com>
	<492CA07F.1030803@sgi.com>	<492CC201.3080304@xfs.org>
	<ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>	<20081209091725.GA26180@infradead.org>
	<493E9AB4.1050505@xfs.org>
	<nccvdtthtyi.fsf@itchy.melbourne.sgi.com>
In-Reply-To: <nccvdtthtyi.fsf@itchy.melbourne.sgi.com>
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
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Niv Sardi wrote:
> Russell Cattelan <cattelan@thebarn.com> writes:
>
>   
>> Christoph Hellwig wrote:
>>
>>     
>>> Now that the xfs-dev branch was updated after a while I tried a git pull
>>> an get a useless error message:
>>>
>>>   
>>>       
>> I agree that is a worthless error message and does nothing to really
>> tell you what the problem is.
>>
>> The problem is that you have a tracking branch for xfs-dev so git
>> wants to leave your branch untouched
>> until you actually want to update it from the remote branch origin/xfs-dev
>> What you can do is:
>> % git-fetch
>> % git-pull . xfs-dev
>>
>> That will pull the latest xfs-dev stuff into your current branch.
>>
>>     
>>> hch@bigmac:~/work/xfs-dev$ git-pull You asked me to pull without
>>> telling me which branch you
>>> want to merge with, and 'branch.origin/xfs-dev.merge' in
>>> your configuration file does not tell me either.  Please
>>> name which branch you want to merge on the command line and
>>> try again (e.g. 'git pull <repository> <refspec>').
>>> See git-pull(1) for details on the refspec.
>>>
>>> If you often merge with the same branch, you may want to
>>> configure the following variables in your configuration
>>> file:
>>>
>>>     branch.origin/xfs-dev.remote = <nickname>
>>>     branch.origin/xfs-dev.merge = <remote-ref>
>>>     remote.<nickname>.url = <url>
>>>     remote.<nickname>.fetch = <refspec>
>>>
>>> See git-config(1) for details.
>>>
>>>
>>> Can you please make each of the current branches a proper git tree
>>> that is easy to work with?  Alternatively I'll just completely stop
>>> bothering with the dev tree if it's such a pain in the ass.
>>>       
>
> Please read git documentation.
>   
seriously?! you need to say this?

>    
> You don't want to be pulling xfs-dev into a xfs/master tree, you should
> setup a remote properly and have local branch tracking them.
>   
Ya and this is a non trivial thing to do without proper instructions.

>   
>> of course this would be so damn confusing if somebody would document
>> the procedures someplace?!
>>     
>
>   
>> Hmm I wonder where we could do that.... ohh wait maybe the WIKI!
>>     
>
> http://xfs.org/index.php?title=Main_Page&action=submit
> --> out of captcha images; this shouldn't happen
>   
Ok fixed.
> you can read this:
>   
Sigh ....
Honestly you think ptools info is useful here?

> ------------------------------------------------------------------------
>
>
> if you s/git.melbourne.sgi.com/oss.sgi.com/
>
> Cheers,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
