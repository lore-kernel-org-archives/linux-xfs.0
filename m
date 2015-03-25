Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA7407F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 07:34:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6828DAC001
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 05:34:10 -0700 (PDT)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id 3OGOJfDqEPedgKP1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Mar 2015 05:34:08 -0700 (PDT)
Received: from host81-136-198-183.in-addr.btopenworld.com ([81.136.198.183]
	helo=[192.168.0.105]) by darcachon.resolversystems.com with esmtpsa
	(TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80)
	(envelope-from <harry@pythonanywhere.com>) id 1YakVZ-0007vg-N0
	for xfs@oss.sgi.com; Wed, 25 Mar 2015 12:34:06 +0000
Message-ID: <5512AB38.7060009@pythonanywhere.com>
Date: Wed, 25 Mar 2015 12:34:00 +0000
From: Harry Percival <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EF1A8F.7030505@pythonanywhere.com>
	<54F856E7.10006@pythonanywhere.com> <54F87BF3.3000405@sandeen.net>
	<54F88CEC.4030009@pythonanywhere.com> <54F89201.60805@sandeen.net>
	<54F893AF.2070406@pythonanywhere.com>
	<54F895FA.4050205@sandeen.net>
	<54F89B47.4010702@pythonanywhere.com>
	<54F8B7D6.2000501@sandeen.net>
	<54F98F20.9000208@pythonanywhere.com>
	<20150306211136.GB13958@dastard>
In-Reply-To: <20150306211136.GB13958@dastard>
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
Cc: xfs@oss.sgi.com

We've written up a sort of post-mortem blog post describing the whole saga:

http://blog.pythonanywhere.com/110/

We've tried hard to avoid kicking off some kind of filesystem flamewar 
while describing the whys and wherefores of our move from xfs to ext4, 
but if you feel we've misrepresented anything, do let us know, I'm sure 
we can adjust the post.

Thanks again to everyone for your help debugging this stuff, and for a 
filesystem which served us excellently for many years.

rgds,
Harry + the team.


On 06/03/15 21:11, Dave Chinner wrote:
> On Fri, Mar 06, 2015 at 11:27:28AM +0000, Harry Percival wrote:
>> Glad we managed to nail down a probable culprit!   Here's hoping
>> Debian and Ubuntu pull in a new kernel :)
>>
>> In other news, any advice on running this
>>
>>      xfstests:src/bstat
>>
>> command as a way of estimating how long a quotacheck will take?
> It will give you an idea - quotacheck uses bulkstat, too.
>
>> Would it still be a useful estimator?  Do you think it would
>> significantly affect the performance of a disk that's under fairly
>> heavy use?
> Of course. Bulkstat drives the disks as hard as they will go.
>
> Cheers,
>
> Dave.

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
