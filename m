Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47246 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757328AbcIWMUm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Sep 2016 08:20:42 -0400
Subject: Re: [PATCH] fstests: make some xfs project quota tests generic
References: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
 <20160923042500.GV27776@eguan.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a834fc9c-c406-022f-8304-2ed54c65bc9b@sandeen.net>
Date: Fri, 23 Sep 2016 07:20:40 -0500
MIME-Version: 1.0
In-Reply-To: <20160923042500.GV27776@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On 9/22/16 11:25 PM, Eryu Guan wrote:
>> @@ -210,16 +226,23 @@ _qmount_option()
>> >  		-e 's/gquota/QUOTA/g'      \
>> >  		-e 's/grpquota/QUOTA/g'    \
>> >  		-e 's/pquota/QUOTA/g'      \
>> > -		-e 's/prjquota/QUOTA/g'      \
>> > +		-e 's/prjquota/QUOTA/g'    \
>> >  		-e 's/quota/QUOTA/g'       \
>> >  		-e 's/uqnoenforce/QUOTA/g' \
>> >  		-e 's/gqnoenforce/QUOTA/g' \
>> >  		-e 's/pqnoenforce/QUOTA/g' \
>> >  		-e 's/qnoenforce/QUOTA/g'  \
>> > -		-e "s/QUOTA/$1/g"`
>> > +		-e "s/QUOTA/$OPTS/g"`
>> >  
>> > +	# ext4 doesn't _do_ "-o pquota/prjquota" because reasons
>> > +	# Switch it to "quota" to enable mkfs-time pquota
>> > +	if [ "$FSTYP" == "ext4" ]; then
>> > +		OPTS=`echo $OPTS \
>> > +		| sed	-e 's/pquota/quota/g'	\
>> > +			-e 's/prjquota/quota/g'`
>> > +	fi
> This replaces "grpquota" to "grquota" and mount failed because of
> unknown mount option "grquota". The following change works for me:
> 
> -             | sed   -e 's/pquota/quota/g'   \
> +             | sed   -e 's/\bpquota/quota/g' \
> 
> If you can give me an ack (or another fix), I can fold it into the
> original patch.

Eek .. yes, feel free to change that (and the other, unless you want
to make it a separate commit) - sorry, not sure how I missed that.

Thanks,
-Eric
