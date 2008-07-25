Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 23:54:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P6sLel023071
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 23:54:22 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com>
	<1216556394-17529-3-git-send-email-david@fromorbit.com>
	<20080722042829.GB27123@infradead.org>
	<20080722053019.GI6761@disturbed>
	<20080722072733.GA15376@infradead.org>
	<20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com>
	<48875040.9090400@thebarn.com> <48881B02.20900@sgi.com>
	<48894ECC.1070609@thebarn.com>
Date: Fri, 25 Jul 2008 16:55:22 +1000
In-Reply-To: <48894ECC.1070609@thebarn.com> (Russell Cattelan's message of
	"Thu, 24 Jul 2008 22:55:56 -0500")
Message-ID: <nccd4l2tput.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: markgw@sgi.com, xfs@oss.sgi.com

Russell Cattelan <cattelan@thebarn.com> writes:
> Mark Goodwin wrote:
>> Russell Cattelan wrote:
>>>> Internally, we're attempting to refine our patch acceptance processes,
>>>> (e.g. gitify our internal dev tree and mirror it on oss so it's much
>>>> easier to push back out to oss).
>>> I'm sure you have seen this before:
>>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-import/.git;a=summary' 

moving from one SCM that is not syncable with the community to another
is not helping at all. While that clone is great to work *with* git, the
commit ids have nothing to do with the community's one, and we stil have
to convert all the work (to fixup commiter names and so forth too) to be
able to be integrated in the community.

>>> That is a running mirror of the ptools tree into git. (via the cvs tree)
>> yes. But it's git -> ptools scripts that we need, preserving
>> history, etc.
>> Niv has some scripts for this - they're not production quality yet, but
>> we're getting there. Once this transitions, it'll be a *lot* easier for
>> us to pull in patches from external developer branches because we'll all
>> be using git for checkin.
> Personally I don't see a reason to keep a ptools tree in lock step with
> with a git tree. I all for not losing history (and I spent a bit of
> time when
> the tree was re-organized to keep the rcs history in tack).
> At this point the git tree has full xfs history and I would think this would
> be sufficient for what ever code archeology  comes up.

for code archeology, we have many other trees. I'm more interested to be
able to answer things like: 'what commits have never made it to linus ?'
(dmapi, patches that had to be slightly changed) and be able to sort all
our mods in 3 categories: merged-upstream (git-patch-id equality),
partly-merged-upstream (commit title equality), unkonwn-upstream.

I have a tree here, ready to be used to replace the internal ptools
tree, it needs some more work to detect the non-merged part of the
partly-merged-upstream, but well, the diff is mostly whitespaces, and I
guess we can discard them.

Hopefully, this can be widely used RSN.

Cheers,
-- 
Niv Sardi
