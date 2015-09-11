Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33FB57CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 19:12:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23A1C304032
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 17:12:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dVPGG5Ap815Griqk for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2015 17:12:41 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 657E165EBB85
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 19:12:40 -0500 (CDT)
Subject: Re: "This is a bug."
References: <20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910173138.GB18940@tarvainen.info>
	<20150910175557.GE27863@bfoster.bfoster>
	<20150910180339.GB18739@tarvainen.info>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55F21C77.6030009@sandeen.net>
Date: Thu, 10 Sep 2015 19:12:39 -0500
MIME-Version: 1.0
In-Reply-To: <20150910180339.GB18739@tarvainen.info>
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
To: xfs@oss.sgi.com

On 9/10/15 1:03 PM, Tapani Tarvainen wrote:
> On Thu, Sep 10, 2015 at 01:55:58PM -0400, Brian Foster (bfoster@redhat.com) wrote:
> 
>>>> So that's a 6TB fs with over 24000 allocation groups of size 256MB, as
>>>> opposed to the mkfs default of 6 allocation groups of 1TB each. Is that
>>>> intentional?
>>>
>>> Not to my knowledge. Unless I'm mistaken, the filesystem was created
>>> while the machine was running Debian Squeeze, using whatever defaults
>>> were back then.
> 
>> Strange... was the filesystem created small and then grown to a much
>> larger size via xfs_growfs?
> 
> Almost certainly yes, although how small it initially was I'm not
> sure.

Oof; with a default of 4 AGs that means that this filesystem was likely
grown from 1G to 6T.

Like Brian says, that is definitely not recommended.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
