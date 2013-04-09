Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 093747FA5
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 17:48:53 -0500 (CDT)
Date: Tue, 9 Apr 2013 17:48:52 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
Message-ID: <20130409224852.GF22182@sgi.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CAJzLF9k3f7ix7GD==26+JDg=5=AQWnJe3aopAHnQxXmzNPRkOw@mail.gmail.com>
	<516493B3.5030106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <516493B3.5030106@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, "Michael L. Semon" <mlsemon35@gmail.com>, =?utf-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hey,

On Tue, Apr 09, 2013 at 05:18:27PM -0500, Eric Sandeen wrote:
> On 4/9/13 5:16 PM, Michael L. Semon wrote:
> > A meager non-expert user question with full ignorance of glusterfs:
> > Why are you having I/O errors once every two weeks?
> 
> It's runtime errors or corruption, followed by fs shutdown, which then
> results in IO errors, because all IOs are rejected on the shutdown FS.
> 
> But that's not always immediately obvious from the stream of resulting
> "I/O Error" messages ;)

The IO errors are maybe a bit excessive and scary.  I can understand why some
people might misinterpret those messages and assume it's a hardware problem.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
