Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B420929DF8
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:57:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D2608F8037
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:57:13 -0700 (PDT)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com
	[209.85.214.172]) by cuda.sgi.com with ESMTP id
	4VWMHXEFi3r21C2q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:57:12 -0700 (PDT)
Received: by mail-ob0-f172.google.com with SMTP id tb18so2648570obb.31
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:57:12 -0700 (PDT)
Message-ID: <519404A0.3030401@gmail.com>
Date: Wed, 15 May 2013 17:56:48 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
References: <5191FB46.2080300@gmail.com>
	<1368650489.10223.5.camel@chandra-dt.ibm.com>
In-Reply-To: <1368650489.10223.5.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: xfs@oss.sgi.com

On 05/15/2013 04:41 PM, Chandra Seetharaman wrote:
> On Tue, 2013-05-14 at 04:52 -0400, Michael L. Semon wrote:
>> Hi!  I seem to have no luck in getting v8 of the pquota/uquota patchset
>> working and have it pass xfstests with flying colors.  Is v8 of the
>> pquota/gquota patchset sufficient to make the new separate pquota/gquota
>> bits work?  Or is it an incremental patchset?
>
> Hi Michael,
>
> I will post the user level changes that accompanies these changes.
>
> With those changes you can do a new mkfs and use pquota and gquota
> together.
>
> Regards,
>
> Chandra

Excellent!

As for the rest of your issues, I'll have to retest very slowly using 
your new userspace patches, documenting every step in order.  It will 
also require before/after runs of xfstests.

I do not know what your patches do for filesystems that already had 
quota on them, so I ask you to check one thing.  It looked like the 
result of the normal `quota` command was having issues.  On my root 
filesystem that was mounted uquota only, the following is the normal 
behavior (as an ordinary user):

mls:~$ quota
Disk quotas for user mls (uid 3001):
      Filesystem  blocks   quota   limit   grace   files   quota   limit 
   grace
       /dev/sda1  165955  262144  327680            2345    8194   16384

However, before I switched out kernels here, such a command just left a 
blank, as if there was no quota there.  If you would at that to your 
list of spot-check tests, that would be great.  It might work fine for 
you.  [For the same situation, `xfs_quota -c quota /` worked just fine.]

You're leading a blind man in the dark, so I thank you for your patience.

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
