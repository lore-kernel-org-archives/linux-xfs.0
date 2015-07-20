Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B16997F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 08:34:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F30530404E
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 06:34:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4qYgBRqWoolWZpeS for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 06:34:10 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: XFS File system in trouble
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <55ACA615.10501@mygrande.net>
Date: Mon, 20 Jul 2015 08:34:07 -0500
Message-Id: <E46BD724-EB28-43F5-ACFA-09BF50DD3A53@sandeen.net>
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net> <20150719232754.GS7943@dastard>
	<55ACA615.10501@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, Kris Rusocki <kszysiu@braxis.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



> On Jul 20, 2015, at 2:41 AM, Leslie Rhorer <lrhorer@mygrande.net> wrote:
> 
>> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>> 
>>>    I found the problem with md5sum (and probably nfs, as well).  One
>>> of the memory modules in the server was bad.  The problem with XFS
>>> persists.  Every time tar tried to create the directory:
>> 
>> Now you need to run xfs_repair.
> 
>    I do that every time the array implodes.  It makes no difference.

Have you done it since you fixed the bad memory problem?

>  It never mentions cleaning the structure tar says needs cleaning,

What does it mention?  AFAICT you haven't yet provided output from repair...

> and the next time I run tar on that file, the filesystem craters.

Brian's suggestion of isolating with metadump is a good one, too.

Eric

> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
