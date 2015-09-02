Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5BFB7F5F
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 20:34:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AAC2AC012
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 18:34:03 -0700 (PDT)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130]) by
	cuda.sgi.com with ESMTP id zROm8yuHaIDDaLFZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 18:33:57 -0700 (PDT)
Subject: Re: Ask help on an issue 'XFS (sd*): discard failed for extent, error
	5'
References: <55E52198.7070607@unitedstack.com> <55E52975.8020005@sandeen.net>
	<55E53C84.1040606@unitedstack.com> <55E59905.80105@sandeen.net>
From: Jevon Qiao <qiaojianfeng@unitedstack.com>
Message-ID: <55E651F9.3020805@unitedstack.com>
Date: Wed, 2 Sep 2015 09:33:45 +0800
MIME-Version: 1.0
In-Reply-To: <55E59905.80105@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 1/9/15 20:24, Eric Sandeen wrote:
> On 9/1/15 12:49 AM, Jevon Qiao wrote:
>> Hi Eric
>>
>> Thank you very much for the prompt response.
>> On 1/9/15 12:28, Eric Sandeen wrote:
>>> On 8/31/15 10:55 PM, Jevon Qiao wrote:
>>>> Hi All,
>>>>
>>>> Currently, I notice that there are lot's of errors written in the /var/log/messages file.
>>>>
>>>>       2015-08-29T23:58:54.477236+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
>>>>       2015-08-29T23:58:54.477255+00:00 server-68 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>>>>       2015-08-29T23:58:54.477256+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
>>>>       2015-08-29T23:58:54.477257+00:00 server-68 kernel: Sense Key : Illegal Request [current]
>>>>       2015-08-29T23:58:54.477258+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
>>>>       2015-08-29T23:58:54.477259+00:00 server-68 kernel: Add. Sense: Invalid field in parameter list
>>>>       2015-08-29T23:58:54.477260+00:00 server-68 kernel: sd 0:0:4:0: [sdc] CDB:
>>>>       2015-08-29T23:58:54.477261+00:00 server-68 kernel: Unmap/Read sub-channel: 42 00 00 00 00 00 00 00 18 00
>>>>       2015-08-29T23:58:54.477263+00:00 server-68 kernel: end_request: critical target error, dev sdc, sector 325046824
>>>>       2015-08-29T23:58:54.477268+00:00 server-68 kernel: XFS (sdc2): discard failed for extent [0x64815,2021], error 5
>>>>
>>>> Has anyone encountered the same issue before? How can you solve it?
>>> Looks like xfs is simply reacting to errors from the storage; I'd try to get
>>> to the bottom of why you're getting all those scsi errors.
>> I just want to understand the meaning of 'XFS (sdc2): discard failed
>> for extent [0x64815,2021], error 5', does it mean one of the layers
>> beneath xfs does not support DISCARD? Could you please show me more
>> clues?
> "error 5" is EIO.  That's as much as I can tell you from the XFS perspective.
>
> I don't know what the block/scsi errors mean, exactly; it does seem as
> if it may not support discard, but it must have advertised that it did, or
> the discard would not have been issued in the first place.
Thank you for the further help on this.
> You haven't said what kernel or storage you're on.
> OTOH, even if you do, it's a scsi/storage issue that the xfs list probably
> can't help much with.
OK, I see.

Thanks,
Jevon
> -Eric
>
>> Thanks,
>> Jevon
>>> But probably not on the xfs list.  :)
>>>
>>> -Eric
>>>
>>>> Thanks,
>>>> Jevon
>>>>
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>>




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
