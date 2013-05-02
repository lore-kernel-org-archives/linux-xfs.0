Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C378F7F56
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 11:08:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF395304059
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 09:08:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pr4gRPcd94tGugrn for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 09:08:37 -0700 (PDT)
Message-ID: <51828F84.3040508@sandeen.net>
Date: Thu, 02 May 2013 11:08:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix internal _xfs_check to handle logdev etc
References: <51827DDF.4050708@redhat.com>
	<1367509132.4098.86.camel@chandra-dt.ibm.com>
In-Reply-To: <1367509132.4098.86.camel@chandra-dt.ibm.com>
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
To: sekharan@us.ibm.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 5/2/13 10:38 AM, Chandra Seetharaman wrote:
> On Thu, 2013-05-02 at 09:53 -0500, Eric Sandeen wrote:
>> Pull all of the old xfs_check script into common/rc:_xfs_check()
>> so that it properly handles all options, including external log
>> devices.
> 
> I see changes only related to USAGE. iiuc, log devices are handled
> properly by current code.

also:

>> +    set -- extra $@
>> +    shift $OPTIND

have you *tested* log devices w/ your original code?  It failed for
Michael and for myself, so...  ;)

-Eric

>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/common/rc b/common/rc
>> index 19a0e18..b47a53e 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -393,8 +393,8 @@ _xfs_check()
>>  {
>>      OPTS=" "
>>      DBOPTS=" "
>> +    USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
>>
>> -    OPTIND=1
>>      while getopts "b:fi:l:stvV" c
>>      do
>>          case $c in
>> @@ -410,8 +410,17 @@ _xfs_check()
>>                  ;;
>>          esac
>>      done
>> -    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
>> -    return $?
>> +    set -- extra $@
>> +    shift $OPTIND
>> +    case $# in
>> +        1)    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
>> +               status=$?
>> +               ;;
>> +        2)    echo $USAGE 1>&1
>> +              status=2
>> +              ;;
>> +    esac
>> +    return $status
>>  }
>>
>>  _setup_large_ext4_fs()
>>
>>
>>
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
