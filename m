Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37D0D7F8C
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 09:11:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23E648F80A1
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 07:11:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id H5jVxkZ7Npvq2sEE for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 07:11:21 -0700 (PDT)
Message-ID: <53C3E50A.3020801@sandeen.net>
Date: Mon, 14 Jul 2014 09:11:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfsprogs: libxcmd/paths: make all comparisons using
	realpath'd paths
References: <53C09034.3070203@redhat.com> <53C090A0.9050403@sandeen.net>
	<20140714123430.GD14369@bfoster.bfoster>
In-Reply-To: <20140714123430.GD14369@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 7/14/14, 7:34 AM, Brian Foster wrote:
> On Fri, Jul 11, 2014 at 08:34:24PM -0500, Eric Sandeen wrote:
>> Both mountpoints and devices can be symlinks, so given a path
>> to look for, and mountpoints/devices from the system, use
>> realpath() on *everything* before making the comparison to see
>> if our path is a match.
>>
>> So, with symlinks for mount points as well as for devices:

<snip>

>> @@ -337,7 +350,7 @@ fs_table_initialise_mounts(
>>  {
>>  	struct statfs	*stats;
>>  	int		i, count, error, found;
>> -	char		*rpath = NULL;
>> +	char		*rpath = NULL, *rmntfromname= NULL, *rmntonname= NULL;
> 
> A couple missing spaces before '=' here.

whoopsies

> The fundamental change looks good, but the memory allocation handling
> seems a little ugly to me. A 'next:' label in the loop that frees the
> path buffers is cleaner IMO. Another option could be to put a couple
> PATH_MAX buffers on the stack or allocate them directly to also
> eliminate the realpath() return value assignment..?

Yeah, that probably makes more sense, thanks.

-eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
