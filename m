Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64261C54FCB
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 19:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D192076C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 19:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w4pfiWBA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgDWTfb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 15:35:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgDWTfb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 15:35:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NJIeZ2082895;
        Thu, 23 Apr 2020 19:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cvWXESNU1PeSCaFhNLVv6ClbaBXtbmdQOyeO33unWCk=;
 b=w4pfiWBAKSmVrLpYmitKZZLvxNU2Y2LFotWmvSGncT9doUhHmIooWdJJHnAQ8aR9pECt
 0/ji67GMeQB4IMZW75ITuYqi9Omf+uf/icazsaxqKu2zRxrzzlriGj1aCaDr3IMMoSAV
 FbeGnc+Z9ANKm7YqAfXIuJe8RV+CNhc0ECUfuw3LmkMVD+L11uQt9Nm/0Os2i+4RTGFc
 jNSBLZ1ue+wpPmgZodGslMYYfV4b3WDqp+ag42lqWreBUxwpQu6JGezaHMfkJ0Kb8H7G
 gfeS4zfFl4bUjzLfreFy+MTVZ0e9yPI+t4iGj1fWS+B749AfS+rX4H04wOg1KY5I/8tD zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30jvq4whs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 19:35:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NJHjZC071756;
        Thu, 23 Apr 2020 19:35:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3w4q4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 19:35:28 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03NJZRVT026035;
        Thu, 23 Apr 2020 19:35:28 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 12:35:27 -0700
Subject: Re: Refactoring the Review Process
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20200422222536.GE6741@magnolia>
 <1fd51acc-c003-85ff-8ca0-2d359973ad32@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <f21d4d1b-b5e6-9111-6e13-80d2ef7c7def@oracle.com>
Date:   Thu, 23 Apr 2020 12:35:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1fd51acc-c003-85ff-8ca0-2d359973ad32@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/20 7:11 AM, Eric Sandeen wrote:
> On 4/22/20 5:25 PM, Darrick J. Wong wrote:
>> Hi everyone,
>>
>> Writing and reviewing code in isolation hasn't always served me well.  I
>> really enjoyed my experiences developing the reflink code (~2015) being
>> able to chat with Dave in the evenings about the design of particular
>> algorithms, or how certain XFS structures really worked, and to learn
>> the history behind this and that subsystem.
>>
>> Returning to first principles, I perceive that the purpose of our review
>> processes is to make sure there aren't any obvious design flaws or
>> implementation errors in the code we put back to the git repo by
>> ensuring that at least one other XFS developer actually understands
>> what's going on.
>>
>> In other words, I am interested in testing the pair programming
>> paradigm.  Given that we have zero physical locality, I suspect this
>> will work better with an interactive medium and between people who are
>> in nearby time zones.  I also suspect that this might be better used for
>> more focussed activities such as code walkthroughs and reviews.  Still,
>> I'm willing to entertain the possibility of using this as a second means
>> to get a patchset to a Reviewed-by.
>>
>> I also speculate that this might be a good mentoring opportunity for us
>> to trade productivity tips and disseminate 'institutional' knowledge
>> between people.  I for one am happy to help others learn more about the
>> code base in exchange for learning more about the parts of XFS with
>> which I'm less familiar.  (I bet Allison knows more about how xattrs
>> work than I do at this point...)
I feel I have a decent understanding at this point, but the challenge 
atm is making it look pretty so it's not so hard for other to look at 
too.  In any case, I'd be happy to walk you through it some time :-)

> 
> Just to chime in, I like this idea.  I think that it's a fairly open-ended
> suggestion, as this could be anything from:
> 
> * True, traditional pair-programming for new work
> * Dividing up tasks for larger projects, and cross-reviewing each others work
> * High-bandwidth review of existing work by interacting directly w/ patch author
>    in real time on irc or video
> * ??? other ideas
I used to work on a team that was very fond of "screen" sessions, though 
maybe limited to people of a common org for vpn reasons.

> 
> In the first couple cases, this might result on patches first appearing on the
> list with a "pre-existing" Reviewed-by that came out of that teamwork.
> 
> As a result we should probably consider a policy that patches remain on the list
> for at least $X days to allow further comment by "3rd parties" if the list is to
> remain (as it should) the ultimate forum for patch acceptance.
That makes sense :-)

> 
> The other thought I have is that while pairing in any of these ways will be an
> excellent growth opportunity (in general, or in a specific area of code) we should
> be somewhat mindful of "lopsided" pairing, i.e. having a guru paired with a total
> newbie for an extremely large, complex project may not be the best idea, but that's
> probably self-evident.  Such teamwork will probably somewhat naturally select into
> logical pairings depending on the task at hand.
> 
> So, for myself, if anyone wants to review anything I've written in real time, or
> would like me to collaborate on their upcoming work, I'm happy to do so within
> the limits of my schedule and bandwidth.  :)
> 
> Thanks,
> -Eric
> 

Yes, I think it would be a beneficial idea too.  Some of the prior teams 
I worked on would have internal reviews before sending things to the 
mailing lists.  It seemed to have the effect of things being a little 
more picked over before sending things to a wider scope of review.  Sort 
of like a low level phase of nits, before going to higher level phase of 
architecture.  It also had the effect of the internal reviewers better 
understanding the design intent before it goes out.  So they tended to 
be more engaged the high level discussion and less engaged on the nits. 
Comparatively it doesn't feel like we have as much division here, so 
everything just happens all at once and I think sometimes people get a 
bit lost in it all.  So perhaps the pair programing approach may help to 
bring a little more structure to our dev process.

Overtime, I suspect the 1x1's may also have the effect of peoples dev 
habits rubbing off on each other too.  Which in general tends to 
generate less things to have a difference of opinion about (in terms of 
design or styles).  People also tend to adopt similar configs or dev 
setups which helps to better pre-disposition them to help each other 
with it later.

Allison
