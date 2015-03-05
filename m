Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB30C7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 11:44:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6AB6304039
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 09:44:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dIEHwmpobx9LelNd for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 09:44:28 -0800 (PST)
Message-ID: <54F895FA.4050205@sandeen.net>
Date: Thu, 05 Mar 2015 11:44:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
References: <54EC958E.2000001@pythonanywhere.com>	<20150224215907.GA18360@dastard>	<54EF1A8F.7030505@pythonanywhere.com>	<54F856E7.10006@pythonanywhere.com>	<54F87BF3.3000405@sandeen.net>	<54F88CEC.4030009@pythonanywhere.com>
	<54F89201.60805@sandeen.net> <54F893AF.2070406@pythonanywhere.com>
In-Reply-To: <54F893AF.2070406@pythonanywhere.com>
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
To: Harry <harry@pythonanywhere.com>, xfs@oss.sgi.com
Cc: "developers@pythonanywhere.com" <developers@pythonanywhere.com>

On 3/5/15 11:34 AM, Harry wrote:
> We're on 3.13.0-39 (Ubuntu Trusty).
> 
> If you're interested in looking into it further, I'd be happy to provide any extra info you'd like?

Well, not really.  It all works here, and you have an ... interesting
setup, so if you've decided that somehow ext4 will save you from
quotachecks in the future, I'm not going to dig a lot further here.

I did already ask for logs, which might tell us why the original quota init
failed, but ... 

> But just to make sure I'm not wasting any of your time -- I think the
> team have pretty much decided to make the switch no matter what. The
> quotacheck issue is one thing, but actually the switch to ext4
> simplifies lots of other aspects of our quota system (one of the
> reasons we picked nfs was to be able to use project quotas, but it
> turns out we don't need them any more, so user quotas are simpler...)

... it sounds like you've already picked your solution to this AFAICT
not-well-understood problem.

*shrug* knock yourself out.  :)  You should use what works best meets your
needs, of course.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
