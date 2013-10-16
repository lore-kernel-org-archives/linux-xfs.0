Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 733277F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 10:14:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02843AC002
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:14:33 -0700 (PDT)
Received: from mail-bk0-f49.google.com (mail-bk0-f49.google.com
	[209.85.214.49]) by cuda.sgi.com with ESMTP id 8y0orfo97M8Ph0Um
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:14:32 -0700 (PDT)
Received: by mail-bk0-f49.google.com with SMTP id w14so323714bkz.22
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:14:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <525EAC5F.3040201@sandeen.net>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
	<525EAC5F.3040201@sandeen.net>
Date: Wed, 16 Oct 2013 16:14:30 +0100
Message-ID: <CAL3q7H6N3K7wda5Rm8OYS5a0QYYQr4MbXpxCpahuXVj+dnzozA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Josef Bacik <jbacik@fusionio.com>, "dsterba@suse.cz" <dsterba@suse.cz>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 4:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
>> This test is motivated by an issue found by a btrfs user, addressed
>> and described by the following GNU/Linux kernel patch:
>>
>> https://patchwork.kernel.org/patch/3046931/
>
> Hi Filipe, thanks for the patch.
>
> Usually we don't want to add new, possibly-failing cases to old tests;
> that makes it harder to identify when the code regressed vs. when
> the test changed to test new things.
>
> It would be better to just copy the framework of tests/shared/051
> to a new test in shared/ and test only this new inheritance
> problem.

Ok, I wasn't aware of that logic, which makes sense.

>
> Also, I'm confused about this hunk:
>
>> @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
>>  getfacl --numeric largeaclfile | _filter_aces
>>
>>  echo "1 above xfs acl max"
>> -chacl $acl3 largeaclfile
>> +if [ "$FSTYP" != "btrfs" ]; then
>> +     chacl $acl3 largeaclfile
>> +else
>> +     echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
>> +fi
>> +
>>  getfacl --numeric largeaclfile | _filter_aces
>>
>>  echo "use 16 aces"
>
> What's that about?

That chacl command succeeds on btrfs, which makes the test fail. Seems
to rely on some xfs specific limit.
By moving this test into a new file, that hack is no longer needed.

Thanks Eric.

>
> Thanks,
> -Eric
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
