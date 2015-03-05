Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E6F77F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 12:07:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C23E30404E
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 10:07:15 -0800 (PST)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id B5iNEEOwmAN9ehFM
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Mar 2015 10:07:12 -0800 (PST)
Received: from host81-136-198-183.in-addr.btopenworld.com ([81.136.198.183]
	helo=[192.168.0.109]) by darcachon.resolversystems.com with esmtpsa
	(TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80)
	(envelope-from <harry@pythonanywhere.com>) id 1YTaAu-000719-OI
	for xfs@oss.sgi.com; Thu, 05 Mar 2015 18:07:09 +0000
Message-ID: <54F89B47.4010702@pythonanywhere.com>
Date: Thu, 05 Mar 2015 18:07:03 +0000
From: Harry <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EC958E.2000001@pythonanywhere.com>	<20150224215907.GA18360@dastard>	<54EF1A8F.7030505@pythonanywhere.com>	<54F856E7.10006@pythonanywhere.com>	<54F87BF3.3000405@sandeen.net>	<54F88CEC.4030009@pythonanywhere.com>	<54F89201.60805@sandeen.net>
	<54F893AF.2070406@pythonanywhere.com>
	<54F895FA.4050205@sandeen.net>
In-Reply-To: <54F895FA.4050205@sandeen.net>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
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
To: xfs@oss.sgi.com

Here's the syslog, if you're curious.

http://pastebin.com/raw.php?i=kKvWJcze

Search for "Failed to initialize"

So your best guess is that it's the drbd layer that's causing the 
quotacheck?  Out of curiosity, i may try mounting a non-drbd drive with 
xfs, and seeing if we can still repro the hard-reboot-causes-quotacheck 
thing...  Unless you think it's just an old behaviour that's more to do 
with the version of the kernel we're using?

HP

On 05/03/15 17:44, Eric Sandeen wrote:
> On 3/5/15 11:34 AM, Harry wrote:
>> We're on 3.13.0-39 (Ubuntu Trusty).
>>
>> If you're interested in looking into it further, I'd be happy to provide any extra info you'd like?
> Well, not really.  It all works here, and you have an ... interesting
> setup, so if you've decided that somehow ext4 will save you from
> quotachecks in the future, I'm not going to dig a lot further here.
>
> I did already ask for logs, which might tell us why the original quota init
> failed, but ...
>
>> But just to make sure I'm not wasting any of your time -- I think the
>> team have pretty much decided to make the switch no matter what. The
>> quotacheck issue is one thing, but actually the switch to ext4
>> simplifies lots of other aspects of our quota system (one of the
>> reasons we picked nfs was to be able to use project quotas, but it
>> turns out we don't need them any more, so user quotas are simpler...)
> ... it sounds like you've already picked your solution to this AFAICT
> not-well-understood problem.
>
> *shrug* knock yourself out.  :)  You should use what works best meets your
> needs, of course.
>
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Rgds,
Harry + the PythonAnywhere team.

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
