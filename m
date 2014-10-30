Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FA917F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 14:14:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2DE668F8033
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 12:14:45 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id zygeTmjTHyKZbweV
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 12:14:43 -0700 (PDT)
Message-ID: <54528E44.5090406@hardwarefreak.com>
Date: Thu, 30 Oct 2014 14:15:16 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: ignore stripe geom if sunit or swidth ==
	physical sector size
References: <544FD3E1.1060000@redhat.com>
	<20141029183721.GA4226@bfoster.laptop>
	<54513635.7050703@sandeen.net> <54515E4E.8010500@hardwarefreak.com>
	<20141030114605.GA5914@bfoster.bfoster>
In-Reply-To: <20141030114605.GA5914@bfoster.bfoster>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 10/30/2014 06:46 AM, Brian Foster wrote:
> On Wed, Oct 29, 2014 at 04:38:22PM -0500, Stan Hoeppner wrote:
>> On 10/29/2014 01:47 PM, Eric Sandeen wrote:
>>> On 10/29/14 1:37 PM, Brian Foster wrote:
>>>> On Tue, Oct 28, 2014 at 12:35:29PM -0500, Eric Sandeen wrote:
>>>>> Today, this geometry:
>>>>>
>>>>> # modprobe scsi_debug  opt_blks=2048 dev_size_mb=2048
>>>>> # blockdev --getpbsz --getss --getiomin --getioopt  /dev/sdd
>>>>> 512
>>>>> 512
>>>>> 512
>>>>> 1048576
>>>>>
>>>>> will result in a warning at mkfs time, like this:
>>>>>
>>>>> # mkfs.xfs -f -d su=64k,sw=12 -l su=64k /dev/sdd
>>>>> mkfs.xfs: Specified data stripe width 1536 is not the same as the volume stripe width 2048
>>>>>
>>>>> because our geometry discovery thinks it looks like a
>>>>> valid striping setup which the commandline is overriding. 
>>>>> However, a stripe unit of 512 really isn't indicative of
>>>>> a proper stripe geometry.
>>>>>
>>>>
>>>> So the assumption is that the storage reports a non-physical block size
>>>> for minimum and optimal I/O sizes for geometry detection. There was a
>>>> real world scenario of this, right? Any idea of the configuration
>>>> details (e.g., raid layout) that resulted in an increased optimal I/O
>>>> size but not minimum I/O size?
>>>
>>> Stan?  :)
>>
>> Yeah, it was pretty much what you pasted sans the log su, and it was a
>> device-mapper device:
>>
>> # mkfs.xfs -d su=64k,sw=12 /dev/dm-0
>>
> 
> What kind of device is dm-0? I use linear devices regularly and I don't
> see any special optimal I/O size reported:

It's a dm-multipath device.  I pasted details up thread.  Here, again:

# multipath -ll
3600c0ff0003630917954075401000000 dm-0 Tek,DH6554
size=44T features='0' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=50 status=active
| `- 9:0:0:3 sdj 8:144 active ready running
`-+- policy='round-robin 0' prio=10 status=enabled
  `- 1:0:0:3 sdf 8:80  active ready running


# blockdev --getpbsz --getss --getiomin --getioopt  /dev/dm-0
512
512
512
1048576

# blockdev --getpbsz --getss --getiomin --getioopt  /dev/sdj
512
512
512
1048576

# blockdev --getpbsz --getss --getiomin --getioopt  /dev/sdf
512
512
512
1048576



Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
