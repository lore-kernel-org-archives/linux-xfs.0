Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:55099 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdFTQG1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 12:06:27 -0400
Subject: Re: Shutdown filesystem when a thin pool become full
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Jun 2017 17:55:26 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170620152858.GA3348@bfoster.bfoster>
References: <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
 <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
 <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
 <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
 <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
 <dee0d3cc198663bb850ef2576c84d620@assyoma.it>
 <20170620152858.GA3348@bfoster.bfoster>
Message-ID: <d30c96bafa9d476e1a381a0aaa1bc285@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 20-06-2017 17:28 Brian Foster ha scritto:
> 
> FWIW, I played with something like this a while ago. See the following
> (and its predecessor for a more detailed cover letter):
> 
>   http://oss.sgi.com/pipermail/xfs/2016-April/048166.html
> 
> You lose some allocation efficiency with this approach because XFS
> relies on a worst case allocation reservation in dm-thin, but IIRC that
> only really manifested when the volume was near ENOSPC. If one finds
> that tradeoff acceptable, I think it's otherwise possible to forward
> ENOSPC from the the block device earlier than is done currently.
> 
> Brian

Very informative thread, thanks for linking. From here [1]:

"That just doesn't help us avoid the overprovisioned situation where we
have data in pagecache and nowhere to write it back to (w/o setting the
volume read-only). The only way I'm aware of to handle that is to
account for the space at write time."

I fully understand that: after all, writes sitting in pagecaches are 
not, well, yet written. I can also imagine what profound ramifications 
would have to correctly cover any failed data writeout corner case. What 
would be a great first step, however, is that at the *first* failed data 
writeout due to full thin pool, a ENOSPC (or similar) to be returned to 
the filesystem. Catching this situation, the filesystem can reject any 
further buffered writes until manual intervention.

Well, my main concern is to avoid sunstained writes to a filled pool, 
surely your patch target a whole bigger (and better!) solution.

[1] http://oss.sgi.com/pipermail/xfs/2016-April/048378.html

> 
>> >
>> > I am not really a device-mapper developer and I don't know much about
>> > its code
>> > in depth. But, I know it will issue warnings when there isn't more space
>> > left,
>> > and you can configure a watermark too, to warn the admin when the space
>> > used
>> > reaches that watermark.
>> >
>> > By now, I believe the best solution is to have a reasonable watermark
>> > set on the
>> > thin device, and the Admin take the appropriate action whenever this
>> > watermark
>> > is achieved.
>> 
>> Yeah, lvmthin *will* return appropriate warnings during pool filling.
>> However, this require active monitoring which, albeit a great idea and 
>> "the
>> right thing to do (tm)", it adds complexity and can itself fail. In 
>> recent
>> enought (experimental) versions, lvmthin can be instructed to execute
>> specific actions when data allocation is higher than some threshold, 
>> which
>> somewhat addresses my concerns at the block layer.
>> 
>> Thank you for your patience and sharing, Carlos.
>> 
>> --
>> Danti Gionatan
>> Supporto Tecnico
>> Assyoma S.r.l. - www.assyoma.it
>> email: g.danti@assyoma.it - info@assyoma.it
>> GPG public key ID: FF5F32A8
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
