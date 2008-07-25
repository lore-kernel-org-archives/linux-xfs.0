Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 22:39:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P5dTG7018464
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 22:39:29 -0700
Message-ID: <48896756.6040101@thebarn.com>
Date: Fri, 25 Jul 2008 00:40:38 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <48875040.9090400@thebarn.com> <48881B02.20900@sgi.com> <48894ECC.1070609@thebarn.com> <488951A1.9000408@sgi.com>
In-Reply-To: <488951A1.9000408@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs@oss.sgi.com

Mark Goodwin wrote:
>
>
> Russell Cattelan wrote:
>> Personally I don't see a reason to keep a ptools tree in lock step with
>> with a git tree. ...
>
> you might not, but you're not working for SGI anymore :)
> We have loads of other trees to merge stuff into other than
> those on oss. 
Ya I'm familiar with the complexity disguising itself as productivity.
(But I will say I experienced a much worse complexity for the sake of
complexity situation)
> Many of the internal scripts for managing this
> are very intertwined with ptools. The one thing that will
> really help with handling externally contributed patches is
> for the primary internal SGI dev tree to become GIT based.
> But not having git->ptools auto merge is not an option.
Actually if auto merge is a requirement I don't really see a shift in
policy. I don't see much difference in a ptool->git vs a git->ptools 
process.

Just because  git is the birthing repo for changes, it seems like that 
is just
drawing more process into things and making change adoption
just as slow if not slower.

It seems like decoupling the process, not just switching SCM's and allowing
experimental  changes to come to light sooner is what people are looking 
for.

>
> PCP is in the same boat, just ask Nathan :)
>
> Looking at this next week ...
>
> Cheers
> -- Mark
>
