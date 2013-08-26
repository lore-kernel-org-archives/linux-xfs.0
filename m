Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F88E7F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 09:29:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2019AC005
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 07:29:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mJlexpbgD7fTVma7 for
	<xfs@oss.sgi.com>; Mon, 26 Aug 2013 07:29:36 -0700 (PDT)
Message-ID: <521B664B.7030404@redhat.com>
Date: Mon, 26 Aug 2013 09:29:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
References: <2909046.09LYLQvZ6q@localhost.localdomain>
	<521A36C6.40006@sandeen.net>
	<44437668.FEX1DiRokR@localhost.localdomain>
In-Reply-To: <44437668.FEX1DiRokR@localhost.localdomain>
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
To: chandan <chandan@linux.vnet.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sekharan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/26/13 12:38 AM, chandan wrote:
> On Sunday, August 25, 2013 11:54:30 AM Eric Sandeen wrote:
>> Can you explain why this is necessary?
>>
>> What failures do you see, on what filesystems?
> 
> generic/255 currently fails on Btrfs on a ppc64 machine with 64k page size and
> hence 64k block size.
> 
> generic/255 has been written to test the corner cases for 4k block size. I did
> try to make it work with variable sized block sizes, But I got stuck
> working with md5sum (since we would need two sets of md5sums, due to
> _test_generic_punch() being invoked with and without '-k' option per block
> size). 
> 
> Since 4k block size support for Btrfs on ppc64 is already being worked on, I
> think its better to prevent execution of generic/255 for block sizes greater
> than 4k.
> 
> Apologies for not including the above description in the patch.

It happens.  ;)

To be honest I haven't really looked at how _test_generic_punch & generic/255
works lately.

Just as a sanity check, does it also fail on xfs for 64k block sizes on ppc64?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
