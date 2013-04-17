Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D15F77F4E
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 08:53:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 952EE304064
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 06:53:31 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	U5jT2uKDfi0ft3g2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 06:53:30 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id 9so1922743iec.36
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 06:53:29 -0700 (PDT)
Message-ID: <516EA959.6090205@gmail.com>
Date: Wed, 17 Apr 2013 09:53:29 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: Practical file system size question
References: <CAFcHYYBBfsoxdaxNaRjnfyG3yVrRJYYfuoA5vNurdmu+1AUCyA@mail.gmail.com>
In-Reply-To: <CAFcHYYBBfsoxdaxNaRjnfyG3yVrRJYYfuoA5vNurdmu+1AUCyA@mail.gmail.com>
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

On 04/17/2013 09:18 AM, Robert Bennett wrote:

[...]

> The question is - does anyone have experience with this type of
> configuration and in particular with 3TB HDDs and a file system size of
> 99TB?  The rebuild time with 2TB drives is ~ 24 hours.  Should I expect

Yes, we've built up to 240TB raw (180TB usable) xfs systems for our 
customers on our units.  Very doable, though there are some considerations.

First off, why 3TB when 4TB are in market, pretty stable ... ?  Unless 
there is a budgetary limitation you are working against, I'd advise at 
least looking at those.

Second, which LSI controllers are you using?  Firmware updates for the 
controllers to use 3TB and higher drives are pretty much mandated.  Our 
experience with various LSI cards has ranged from not so good to pretty 
good, and this is a firmware version revision dependent (along with 
driver) issue from what we found.

> the rebuild time for the 3TB drives to be ~ 36 hours?

Not in our experience.  Typically 5-10 hours depending upon RAID card 
used, RAID configuration, drives chosen, and other issues.  Its pretty 
complex, and hard to predict in advance without trying it.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/siflash
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
