Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NJaxmj106938 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 13:36:59 -0600
Message-ID: <49A2F933.3090308@sandeen.net>
Date: Mon, 23 Feb 2009 13:29:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs/xfsdump release process
References: <200902221348.51905.vapier@gentoo.org>	<20090223072207.GA4112@infradead.org>	<DCA2D97E-F9A4-4A9E-BC39-CFFF1D0AD2CD@sgi.com>	<200902231125.44076.vapier@gentoo.org>
	<FF190F30-2ECF-49D7-B63F-EF65C076EC7A@sgi.com>
In-Reply-To: <FF190F30-2ECF-49D7-B63F-EF65C076EC7A@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

Felix Blyakher wrote:
> On Feb 23, 2009, at 10:25 AM, Mike Frysinger wrote:
> 
>> On Monday 23 February 2009 11:10:44 Felix Blyakher wrote:
>>> On Feb 23, 2009, at 1:22 AM, Christoph Hellwig wrote:
>>>> On Sun, Feb 22, 2009 at 11:00:45PM -0600, Felix Blyakher wrote:
>>>>> Mike, you're absolutely right here. The config files got into the
>>>>> dmapi tarball by mistake, sorry for this. I verified that neither
>>>>> xfsprogs nor xfsdump have any extra files. New (clean) dmapi  
>>>>> tarball
>>>>> will be on the oss site shortly.
>>>> Please don't overwrite already uploaded tarballs.  Let's make a  
>>>> 2.2.10
>>>> release instead.  We might just use the Makepkgs script for it after
>>>> fixing it.  See the question and patch on the list for xfsprogs for
>>>> that, haven't checked dmapi works right yet.
>>> Didn't think that removing the unneeded files from the package
>>> justifies the version bump. It doesn't change anything for people
>>> who already downloaded unclean dmapi tarballs.
>>> Though, if opinion on this matter is that strong, I'd definitely
>>> bump the version, and will use updated Makepkgs.
>> the problem is for people (like Gentoo) who already fetched the  
>> tarball,
>> hashed it, and posted the resulting URL/hash to their packaging  
>> systems ...
> 
> OK, that's definitely convincing.

Just FWIW, Fedora does similar.  Changing md5sums on a released,
versioned tarball could set off all sorts of worries for distributions,
in general...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
