Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 09 Mar 2007 07:34:00 -0800 (PST)
Received: from youju.siksai.co.uk (youju.siksai.co.uk [87.127.14.180])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l29FXs6p024336
	for <xfs@oss.sgi.com>; Fri, 9 Mar 2007 07:33:56 -0800
Received: from xiao.siksai.co.uk ([87.127.14.179] ident=rhowe)
	by youju.siksai.co.uk with smtp (Exim 4.50)
	id 1HPgSY-0005BH-QQ
	for xfs@oss.sgi.com; Fri, 09 Mar 2007 14:52:52 +0000
From: "Russell Howe" <rhowe@siksai.co.uk>
Date: Fri, 9 Mar 2007 14:54:01 +0000
Subject: Andrew Morton talking about filesystems at FOSDEM 2007
Message-ID: <20070309145400.GA23808@xiao.rsnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Just thought this might be of interest to some folks on the list - akpm
gave a talk at FOSDEM about the kernel and various bits & pieces and
someone asked about filesystems during the Q&A session.

Full video available from http://www.fosdem.org/2007/media/video

"Hi. Um, earlier you were a little bit scathing about ext4. Um, what are the
alternatives? Hans Reiser doesn't appear to be at FOSDEM this year. Is ZFS
likely to get merged in, or are there any other possibilities there and what
sucks about ext4? What don't you like?"

"Sorry, which filesystems did you mention?"

"ext4?"

"Yep, I thought you mentioned some other filesystems"

"Oh, ZFS, the Sun..."

"ZFS? Well, um I've yet to see the patch [chuckles]. I'm not aware of any
Sun-supported effort to do that. ext3? Well, I've worked on ext3 for so long
I'm kinda sick of it I guess. It doesn't perform very well. The way in which it
journals is a little bit klunky, and there are many things I'd like to do to it
but simply do not have time to. So I think the block based journalling probably
wasn't the right way to do it. It was a good way to get a journalling
filesystem that was compatible with ext2 but I think logical journalling is
probably / would have been a smarter approach to take. Also, the performance of
ext3 is not great. Occasionally when I get time I'll get down and run some
benchmarks against XFS and I just scratch my head and I just do not know how
XFS does some of the things it does. Particularly with respect to file layout,
it is astonishingly good. But unfortunately with XFS the codebase is so complex
we're not / really vendors are not supporting it, so erm in some ways that's
just [??] so few people understand XFS internals, one of the attractive things
about ext3 and ext4 is that so many different companies have engineers working
on it. So erm given we got this excellent performance but very complicated
codebase which few people understand and on the other side we've got one which
doesn't perform so well but a lot of people understand it seems the decision's
been taken to evolve the slower but well understood one. It could be JFS is a
good filesystem now as well. JFS had reputational problems in the first couple
of years when it tended to crash a lot. That may not be the case any more but
I'm just not aware of anybody who's using JFS much any more. But I'd imagine
xfs... ext4 should be getting as good as XFS on file layout by the end of the
year. How it'll compare on the benchmarks I don't know yet."

[question indistinct] "... shadow copying, things like that?"

"Nope, no there are no plans for fancy features like that that I'm aware of. At
this stage we're simply trying to get the bandwidth, lock contention, file
layout and those sorts of issues sorted out."


-- 
Russell Howe       | Why be just another cog in the machine,
rhowe@siksai.co.uk | when you can be the spanner in the works?
