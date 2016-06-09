Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB5157CB1
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 21:56:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43685AC002
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 19:56:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GlQN6WA4RrsZGVsO for <xfs@oss.sgi.com>;
	Wed, 08 Jun 2016 19:56:22 -0700 (PDT)
Subject: Re: crash in xfs in current
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
	<CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
	<CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
	<20160609022238.GY26977@dastard>
	<CAAA5faGL_Nyu=jW2Vrgr_m7crhnB9BriWWzMAPODbiQATFhS=Q@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <00bbe658-a891-3771-ca1d-5661a8b6ab61@sandeen.net>
Date: Wed, 8 Jun 2016 21:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAAA5faGL_Nyu=jW2Vrgr_m7crhnB9BriWWzMAPODbiQATFhS=Q@mail.gmail.com>
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
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Daniel Wagner <wagi@monom.org>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On 6/8/16 9:53 PM, Reinoud Koornstra wrote:

>> In your Linus git tree:
>>
>> $ git remote add xfsdev git://git.kernel.org/git/dgc/linux-xfs.git
>> $ git remote update
>> $ git checkout -b xfsdev-merge v4.6
>> $ git merge xfsdev/xfs-for-linus-4.7-rc1
> 
> Tried to do this:
> 
> reinoud@router-dev:~/Downloads/kernel_current$  git remote add xfsdev
> git://git.kernel.org/git/dgc/linux-xfs.git

I think that should be:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

-Eric

> reinoud@router-dev:~/Downloads/kernel_current$  git remote update
> Fetching origin
> Fetching xfsdev
> fatal: remote error: access denied or repository not exported:
> /git/dgc/linux-xfs.git
> error: Could not fetch xfsdev
> 
> I don't think I have access to git.kernel.org in terms of pushing. :)
> Or am I doing something else wrong.
> Forgive the trivial question.
> 
> Btw, I started in the most current linus git tree.... or should I git
> 4.6.y and then do your suggestions?
> 
> Thanks,
> 
> Reinoud.
> 
>>
>> And that should give you the XFS changes for 4.7-rc1 in a vanilla 4.6
>> tree. This merge is one of the things I test (i.e. send to my test
>> machiens for a round of xfstests and other stress) before sending a
>> pull request to Linus, so it should work just fine.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
