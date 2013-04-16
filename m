Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 299657F3F
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 07:39:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 166E28F80B5
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 05:39:07 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id kIjBZCav63PEGzJp (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 05:39:06 -0700 (PDT)
Subject: Bug#705483: xfsprogs: xfs_quota misinterprets usernames with leading
	digits
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.705483.B705483.136611576726057@bugs.debian.org>
Message-ID: <516D443C.3020903@sgi.com>
Date: Tue, 16 Apr 2013 07:29:48 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
References: <516C12DB.3060806@bytemark.co.uk> <516C25AC.60506@sgi.com>
	<516D0911.5080408@bytemark.co.uk>
In-Reply-To: <516D0911.5080408@bytemark.co.uk>
Reply-To: Rich Johnston <rjohnston@sgi.com>, 705483@bugs.debian.org
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
To: James Carter <james.carter@bytemark.co.uk>, 705483@bugs.debian.org

On 04/16/2013 03:17 AM, James Carter wrote:
> On 15/04/13 17:07, Rich Johnston wrote:
>>
>> I don't think this is a bug, username must begin with a character
>> (unless you created the user using NIS or adduser --force-badname).
>
> My understanding that this is a recommendation rather than a
> requirement. useradd(8) has the following to say:
>
>         On Debian, the only constraints are that usernames must neither
> start
>         with a dash ('-') nor contain a colon (':') or a whitespace
> (space: '
>         ', end of line: '\n', tabulation: '\t', etc.). Note that using a
> slash
>         ('/') may break the default algorithm for the definition of the
> user's
>         home directory.
>
> In any case, I'd still consider it a bug that trailing non-numeric
> characters were just silently ignored.
>

Interesting I was not aware of the Debian difference.  My understanding 
was that usernames with leading digits would have trouble with other 
utilities on other versions of Unix and flavors of Linux as they would 
interpret the username as numeric UID.  I was able to create a user with 
leading digits and trailing alpha characters using vipw.  Because  chown 
works using this username, we will look into fixing this bug.  Thanks 
for pointing it out.

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
