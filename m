Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0860D7F47
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 13:47:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A96AAC001
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 11:47:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HqCg6RsLWpYG97L7 for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 11:47:18 -0700 (PDT)
Message-ID: <54513635.7050703@sandeen.net>
Date: Wed, 29 Oct 2014 13:47:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: ignore stripe geom if sunit or swidth ==
	physical sector size
References: <544FD3E1.1060000@redhat.com>
	<20141029183721.GA4226@bfoster.laptop>
In-Reply-To: <20141029183721.GA4226@bfoster.laptop>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs-oss <xfs@oss.sgi.com>

On 10/29/14 1:37 PM, Brian Foster wrote:
> On Tue, Oct 28, 2014 at 12:35:29PM -0500, Eric Sandeen wrote:
>> Today, this geometry:
>>
>> # modprobe scsi_debug  opt_blks=2048 dev_size_mb=2048
>> # blockdev --getpbsz --getss --getiomin --getioopt  /dev/sdd
>> 512
>> 512
>> 512
>> 1048576
>>
>> will result in a warning at mkfs time, like this:
>>
>> # mkfs.xfs -f -d su=64k,sw=12 -l su=64k /dev/sdd
>> mkfs.xfs: Specified data stripe width 1536 is not the same as the volume stripe width 2048
>>
>> because our geometry discovery thinks it looks like a
>> valid striping setup which the commandline is overriding. 
>> However, a stripe unit of 512 really isn't indicative of
>> a proper stripe geometry.
>>
> 
> So the assumption is that the storage reports a non-physical block size
> for minimum and optimal I/O sizes for geometry detection. There was a
> real world scenario of this, right? Any idea of the configuration
> details (e.g., raid layout) that resulted in an increased optimal I/O
> size but not minimum I/O size?

Stan?  :)

> This seems reasonable to me and the code looks fine, save a trailing
> whitespace instance below. 

Doh!   >:(     ;) thanks.

> I'm just curious if there are any weird
> corner cases where there's value in the reported optimal I/O size or the
> real world situation was just noise.

yeah, hard to know - How *would* you use it?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
