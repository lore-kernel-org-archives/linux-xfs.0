Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VINhA1191965 for <xfs@oss.sgi.com>; Mon, 31 May 2010 13:23:44 -0500
Received: from mailgate.ics.forth.gr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BBF0158070F
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:28:22 -0700 (PDT)
Received: from mailgate.ics.forth.gr (mailgate.ics.forth.gr [139.91.1.2]) by
	cuda.sgi.com with ESMTP id IKWTkZL28mUxGdK2 for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 11:28:22 -0700 (PDT)
Message-ID: <4C03FF19.2070608@ics.forth.gr>
Date: Mon, 31 May 2010 21:25:29 +0300
From: Yannis Klonatos <klonatos@ics.forth.gr>
MIME-Version: 1.0
Subject: Re: xfs_buf and buffercache/pagecache connection
References: <4C03E46B.9040407@ics.forth.gr> <87aargt0ap.fsf@basil.nowhere.org>
In-Reply-To: <87aargt0ap.fsf@basil.nowhere.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0681213002595006153=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============0681213002595006153==
Content-Type: multipart/alternative;
 boundary="------------030401060206070607000305"

This is a multi-part message in MIME format.
--------------030401060206070607000305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

???? 5/31/2010 9:04 PM, O/H Andi Kleen ??????:
> Yannis Klonatos<klonatos@ics.forth.gr>  writes:
>
>    
>>          I was looking to add a kernel hook to my system in order to
>> monitor buffer-cache hit and misses. Initially I was
>> planning to add my modifications to the __getblk(). However, i noticed
>> that XFS does not directly use the buffer-cache
>> for its pages but it seems to implement its own buffer.
>>          What I am now looking for is 1) the place where XFS checks
>> whether a page exists in its buffer or not and 2)
>> what are the possible interactions between xfs_buf and the Linux
>> kernel buffer-cache.
>>          I would appreciate any information regarding the above issues.
>>      
> The kernel does not track all accesses, e.g. through mmap.
> So you can only get misses (which is essentially IO rate and already
> accounted), but not hits.
>
> -Andi
>    

First of all thanks for your quick reply.

So, if i understand correctly, what you are saying is that it is 
basically impossible to modify xfs code
so that i get that specific information? This sounds a bit strange since 
if XFS was indeed using the
buffercache as ext3 or other fs does, the following modification would 
suffice (file fs/buffer.c):

structbuffer_head  <+code=buffer_head>  *
find_get_block  <+code=__find_get_block>(structblock_device  <+code=block_device>  *bdev  <+code=bdev>,sector_t  <+code=sector_t>  block  <+code=block>, intsize  <+code=size>) {

      	structbuffer_head  <+code=buffer_head>  *bh  <+code=bh>  =lookup_bh_lru  <+code=lookup_bh_lru>(bdev  <+code=bdev>,block  <+code=block>,size  <+code=size>);
	/* BEGIN MODIFICATION */
	if (bh) buffercache_hits++;
	else buffercache_misses++;
	/* END MODIFICATION */
         if (bh  <+code=bh>  ==NULL  <+code=NULL>) {
                bh  <+code=bh>  =__find_get_block_slow  <+code=__find_get_block_slow>(bdev  <+code=bdev>,block  <+code=block>);
                if (bh  <+code=bh>)
                        bh_lru_install  <+code=bh_lru_install>(bh  <+code=bh>);
        }
        if (bh  <+code=bh>) {
                touch_buffer  <+code=touch_buffer>(bh  <+code=bh>);
        returnbh  <+code=bh>;

}

XPORT_SYMBOL  <+code=EXPORT_SYMBOL>(__find_get_block  <+code=__find_get_block>);



--------------030401060206070607000305
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
&#963;&#964;&#953;&#962; 5/31/2010 9:04 PM, O/H Andi Kleen &#941;&#947;&#961;&#945;&#968;&#949;:
<blockquote cite="mid:87aargt0ap.fsf@basil.nowhere.org" type="cite">
  <pre wrap="">Yannis Klonatos <a class="moz-txt-link-rfc2396E" href="mailto:klonatos@ics.forth.gr">&lt;klonatos@ics.forth.gr&gt;</a> writes:

  </pre>
  <blockquote type="cite">
    <pre wrap="">        I was looking to add a kernel hook to my system in order to
monitor buffer-cache hit and misses. Initially I was
planning to add my modifications to the __getblk(). However, i noticed
that XFS does not directly use the buffer-cache
for its pages but it seems to implement its own buffer.
        What I am now looking for is 1) the place where XFS checks
whether a page exists in its buffer or not and 2)
what are the possible interactions between xfs_buf and the Linux
kernel buffer-cache.
        I would appreciate any information regarding the above issues.
    </pre>
  </blockquote>
  <pre wrap="">
The kernel does not track all accesses, e.g. through mmap.
So you can only get misses (which is essentially IO rate and already
accounted), but not hits.

-Andi
  </pre>
</blockquote>
<br>
First of all thanks for your quick reply.<br>
<br>
So, if i understand correctly, what you are saying is that it is
basically impossible to modify xfs code<br>
so that i get that specific information? This sounds a bit strange
since if XFS was indeed using the <br>
buffercache as ext3 or other fs does, the following modification would
suffice (file fs/buffer.c):<br>
<br>
<span class="Apple-style-span"
 style="border-collapse: separate; color: rgb(0, 0, 0); font-family: 'Times New Roman'; font-style: normal; font-variant: normal; font-weight: normal; letter-spacing: normal; line-height: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; font-size: medium;"><span
 class="Apple-style-span" style="font-family: sans-serif;">
<pre class="done" id="47/d4/e8f84d9c5bc4a779e65d674345bd8729d9aa_3/1000"
 style="margin-left: 0px; margin-top: 0px; margin-bottom: 0px; padding-top: 0px; padding-bottom: 0px;">struct <a
 href="+code=buffer_head" class="sref">buffer_head</a> *
<a href="+code=__find_get_block" class="sref">find_get_block</a>(struct <a
 href="+code=block_device" class="sref">block_device</a> *<a
 href="+code=bdev" class="sref">bdev</a>, <a href="+code=sector_t"
 class="sref">sector_t</a> <a href="+code=block" class="sref">block</a>, int <a
 href="+code=size" class="sref">size</a>) {

     	struct <a href="+code=buffer_head" class="sref">buffer_head</a> *<a
 href="+code=bh" class="sref">bh</a> = <a href="+code=lookup_bh_lru"
 class="sref">lookup_bh_lru</a>(<a href="+code=bdev" class="sref">bdev</a>, <a
 href="+code=block" class="sref">block</a>, <a href="+code=size"
 class="sref">size</a>);
	/* BEGIN MODIFICATION */
	if (bh) buffercache_hits++;
	else buffercache_misses++;
	/* END MODIFICATION */
        if (<a href="+code=bh" class="sref">bh</a> == <a
 href="+code=NULL" class="sref">NULL</a>) {
               <a href="+code=bh" class="sref">bh</a> = <a
 href="+code=__find_get_block_slow" class="sref">__find_get_block_slow</a>(<a
 href="+code=bdev" class="sref">bdev</a>, <a href="+code=block"
 class="sref">block</a>);
               if (<a href="+code=bh" class="sref">bh</a>)
                       <a href="+code=bh_lru_install" class="sref">bh_lru_install</a>(<a
 href="+code=bh" class="sref">bh</a>);
       }
       if (<a href="+code=bh" class="sref">bh</a>) {
               <a href="+code=touch_buffer" class="sref">touch_buffer</a>(<a
 href="+code=bh" class="sref">bh</a>);
       return <a href="+code=bh" class="sref">bh</a>;

}

<a href="+code=EXPORT_SYMBOL" class="sref">XPORT_SYMBOL</a>(<a
 href="+code=__find_get_block" class="sref">__find_get_block</a>);</pre>
</span></span><br>
</body>
</html>

--------------030401060206070607000305--


--===============0681213002595006153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0681213002595006153==--
