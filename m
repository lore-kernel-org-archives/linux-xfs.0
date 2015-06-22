Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E09C7F51
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 20:54:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7ACE6304051
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 18:54:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FXtGBXGptni6rAFx for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 18:54:15 -0700 (PDT)
Message-ID: <55876AC6.2080407@sandeen.net>
Date: Sun, 21 Jun 2015 20:54:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_metadump: obfuscate remote symlinks on CRC filesystems
References: <55847BE8.8010908@redhat.com>
	<20150621091419.GA26833@infradead.org>
In-Reply-To: <20150621091419.GA26833@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/21/15 4:14 AM, Christoph Hellwig wrote:
> On Fri, Jun 19, 2015 at 03:30:32PM -0500, Eric Sandeen wrote:
>> On CRC filesystems, the symlink block starts with a header,
>> which contains magic, "XLSM"
>>
>> The code happens to "work" today w/o corrupting anything,
>> because it seems "XSLM" as a string, decides it's too short
>> to obfuscate, and leaves it alone.
>>
>> But the real symlink target is untouched.  Fix that by moving
>> the pointer to the string we want to obfuscate by the size
>> of the header, and shorten the length to obfuscate accordingly.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Any chance to get a test for this into xfstests?

I have a larger metadump testcase brewing, it'd cover this too.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
