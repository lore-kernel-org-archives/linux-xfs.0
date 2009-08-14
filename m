Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7EDoCVD107915 for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 08:50:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 845898F8111
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 06:50:58 -0700 (PDT)
Message-Id: <A19572B5-36F2-447D-A0F5-96405150ED5E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A84B050.4020500@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XFS corruption with failover
Date: Fri, 14 Aug 2009 08:21:57 -0500
References: <4A8474D2.7050508@jquigley.com>
	<E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
	<4A84B050.4020500@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: John Quigley <jquigley@jquigley.com>, XFS Development <xfs@oss.sgi.com>


On Aug 13, 2009, at 7:31 PM, Eric Sandeen wrote:

>> This is an IO error. Is the block device (/dev/sde) accessible
>> from the server #2 OK? Can you dd from that device?
>
> Are you sure?

No, I'm not. Replied first without looking at the code ^)

>
>
>                if (ohead->oh_clientid != XFS_TRANSACTION &&
>                    ohead->oh_clientid != XFS_LOG) {
>                        xlog_warn(
>                "XFS: xlog_recover_process_data: bad clientid");
>                        ASSERT(0);
>                        return (XFS_ERROR(EIO));
>                }
>
> so it does say EIO but that seems to me to be the wrong error; loks  
> more
> like a bad log to me.

Agree. It does look like corrupted (incomplete) log.

>
>
> It does make me wonder if there's any sort of per-initiator caching on
> the iscsi target or something.  </handwave>

Yep, somewhere piece of log left out in a cache, and wasn't flushed
to disk.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
